//
//  NewCardTableViewController.swift
//  Flist
//
//  Created by Роман Широков on 30.03.18.
//  Copyright © 2018 Flist. All rights reserved.
//

import UIKit

class NewCardTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Data from the previous view.
    // It shows whether we in the proccess of modifying existing card or in the creating new one.
    public var cardToEdit: CardElement? // Var is assigned during the segue if it must be modified
    public var groups: [CardGroup]? // Existing card groups

    private var isModifying: Bool { // Checks what proccess is now (editing or creating)
        return cardToEdit != nil
    }
    
    // Data from the Link Account View (template or custom)
    var customIconImg: UIImage? {
        willSet(customIcon) {
            cardIconImg.image = (customIcon == nil) ? ServiceModel.services[0].icon : customIcon
        }
    }
    
    var cardType: String! = "none" {
        willSet(newValue) { // If willSet var, then also set corresponding iconImg (if it isn't custom)
            
            let service = ServiceModel.getTypeByShortcut(newValue)
            
            cardIconImg.image = service.icon
            cardNameField.text = service.name
            
        }
    }
    
    var linkToService: String? {
        willSet(newValue) { cardLinkLabel.text = newValue } // If willSet var, then also set link field
    }
    
    var usernameToService: String? {
        willSet(newValue) { cardUsernameField.text = newValue }
    }
    
    //Data of the current view
    let model = ProfileManageModel()

    var selectedRowInGroupPicker: Int = 0 {
        willSet(row) {            
            if row == 0 {
                groupPickerField.text = "None"
            } else if groups![0].id == "0" {
                groupPickerField.text = groups![row].name
            } else {
                groupPickerField.text = groups![row-1].name
            }
        }
    }
    var isIconUploading: Bool = false
    
    // MARK: Card Creation Outlets
    @IBOutlet weak var cardIconImg: UIImageView! // Icon that represents card (social network icon)
    @IBOutlet weak var cardLinkLabel: UILabel! // Link to the account
    @IBOutlet weak var cardUsernameField: UITextField! // Specify username for the account for card
    
    @IBOutlet weak var cardNameField: UITextField! // Name of the card
    @IBOutlet weak var cardDescriptionField: UITextView! // Description of the card
    @IBOutlet weak var cardPrivacyPicker: UISegmentedControl! // Privacy setting (0 - public; 1 - friends; 2 - custom)
    @IBOutlet weak var groupPickerField: UITextField! // TextField for group name
    
    @IBOutlet weak var cardUploadBtn: UIButton! // Button to start uploading of the card to server
    private var cardUploadIndView: UIActivityIndicatorView? // Indicator that will show the card upload proccess
    
    public func InitializeController(card: CardElement? = nil, groups: [CardGroup]? = nil) {

        if let crd = card { self.cardToEdit = crd }
        self.groups = groups
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupGroupPicker() // Group picker setup
        SetupViewTitle ()
        SetupUIElements()
        SetupUploadCardIndicator()
    }
    
    private func SetupViewTitle () {
        
        if isModifying, let card = cardToEdit {
            
            self.navigationItem.title = "Edit Card"
            cardUploadBtn.setTitle("Save", for: .normal)
            
            cardIconImg.image = card.img
            cardType = card.type
            
            cardLinkLabel.text = card.url
            cardNameField.text = card.name
            cardUsernameField.text = card.username
            cardDescriptionField.text = card.desc
            
            selectedRowInGroupPicker = GetRowByGroupID(id: card.group_id)
            
            
        } else { groupPickerField.text = "None" }
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    private func SetupUIElements() {
        
        if let crdType = cardType, let lnk = linkToService, let usrn = usernameToService {
            cardIconImg.image = ServiceModel.getTypeByShortcut(crdType).icon
            cardLinkLabel.text = lnk
            cardUsernameField.text = usrn
        }
        
        
    }
    
    private func SetupGroupPicker () {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.lightGray
        
        let doneBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.GroupPicked))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = "Select a group"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneBarBtn], animated: true)
        
        groupPickerField.inputAccessoryView = toolBar
        
    }
    
    private func SetupUploadCardIndicator() {
        
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        
        indicator.color = UIColor.mainColorTheme
        indicator.center = cardUploadBtn.center
        
        cardUploadIndView = indicator
        self.cardUploadBtn.superview?.addSubview(cardUploadIndView!)
        
    }
    
    private func SetActivityIndicatorState(_ state: Bool) {
        cardUploadBtn.isHidden = state
        
        if state { cardUploadIndView?.startAnimating() }
        else { cardUploadIndView?.stopAnimating() }
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        // Disable all interactable elements, while uploading
        cardLinkLabel.isUserInteractionEnabled = !state
        cardNameField.isUserInteractionEnabled = !state
        cardUsernameField.isUserInteractionEnabled = !state
        cardPrivacyPicker.isUserInteractionEnabled = !state
        cardDescriptionField.isUserInteractionEnabled = !state
    }
    
    // MARK: GROUP PICKER
    
    @IBAction func GroupFieldAction(_ sender: UITextField) {
    
        let pickerView: UIPickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if let card = cardToEdit // If we're editing existing card, select it's group
        {
            pickerView.selectRow(GetRowByGroupID(id: card.group_id), inComponent: 0, animated: false)
        }
        else // Otherwise, select empty group
        {
            pickerView.selectRow(0, inComponent: 0, animated: false)
        }
        
        groupPickerField.inputView = pickerView
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let gr = groups, gr.count > 0 {
            
            // In the picker we need to have an empty group
            if gr[0].id == "0" { return gr.count } // If there is already one in the array of groups, then return its count
            else { return gr.count+1 } // Otherwise, return count with one extra.
            
        } else { return 1 } // If groups array is empty, in the picker will be just one empty group to choose from
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 { return "None" } // The first row of picker is an empty ("none") group
        else // Other groups are named from the groups' array
        {
            // If the 1st group is an empty group, then count as it is
            // Otherwise, the array's actual count is lesser by 1, than we need (there is one extra row for empty group).
            let rw = groups?[0].id == "0" ? row : row-1
            
            return groups?[rw].name
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        groupPickerField.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        selectedRowInGroupPicker = row
        
    }
    
    @objc func GroupPicked(sender: UIBarButtonItem) {
        groupPickerField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func GetGroupIDByRow(row: Int) -> String {
        
        if let gr = groups, row > 0 {
            if gr[0].id == "0" { return gr[row].id }
            else { return gr[row-1].id }
        }
        return "0"
    }
    
    private func GetRowByGroupID(id: String) -> Int {
        
        if let grs = groups, id != "0" {
            for i in 0...grs.count-1 {
                if id == grs[i].id { return i+1 }
            }
        }
        return 0
        
    }
    
    
    // MARK: UPLOAD LOGIC
    
    
    @IBAction func CreateCardAction(_ sender: Any) {
        
        SetActivityIndicatorState(true)
        
        var data = [String: Any]() // Data Array that will be uploaded to the server
        var card_id: String
        
        if ( CheckFieldsOnEmptyness() ) { return }
        
        if isModifying, let card = cardToEdit {
            
            // Read all fields' values
            let name = cardNameField.text
            let username = cardUsernameField.text
            let desctipt = cardDescriptionField.text
            let url = cardLinkLabel.text
            let group_id = GetGroupIDByRow(row: selectedRowInGroupPicker)
            
            // If any field is modified, insert it to the data array
            if cardType != card.type { data["type"] = cardType }
            if name != card.name { data["name"] = name }
            if username != card.username { data["username"] = username }
            if desctipt != card.desc { data["description"] = desctipt }
            if url != card.url  { data["url"] = url }
            if group_id != card.group_id { data["group_id"] = group_id }
            
            card_id = card.id
            
            // If any field is modified (data != empty), update corresponding card on the server
            if data.count > 0 { model.updateCard(data, id: card.id) }
            
        } else  {

            data["type"] = cardType
            data["group_id"] = GetGroupIDByRow(row: selectedRowInGroupPicker)
            data["name"] = cardNameField.text
            data["username"] = cardUsernameField.text
            data["privacy"] = cardPrivacyPicker.selectedSegmentIndex
            data["url"]  = cardLinkLabel.text
            data["description"] = cardDescriptionField.text.isEmpty ? cardNameField.text : cardDescriptionField.text
            
            card_id = model.addCard(data) // Add new card to the server
    
        }
        
        if cardType == "none", let img = customIconImg {
                        
            isIconUploading = true
            
            let reseizedImg = ProfileManageModel.ResizeImage(image: img, targetSize: CGSize(width: 225, height: 225))
            model.uploadCustomCardIcon(card_id: card_id, img: reseizedImg, completionHandler: {
                
                
                self.ReloadPreviousTableView()
                self.navigationController?.popViewController(animated: true)
            })
            
        }
        
        if !isIconUploading {
            
            if data.count > 0 { ReloadPreviousTableView() }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func CheckFieldsOnEmptyness() -> Bool {
        
        if  (cardNameField.text?.isEmpty)! ||
            (cardUsernameField.text?.isEmpty)! ||
            (cardLinkLabel.text?.isEmpty)!
        {
            SetActivityIndicatorState(false)
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.ShowAlert(msg: "All of the input fields must be filled!")
            return true
        }
            
        return false
    }
    
    private func ReloadPreviousTableView () {
        if let viewControllers = self.navigationController?.viewControllers {
            
            let count = viewControllers.count
            if count > 1 {
                if let vc = viewControllers[count - 2] as? MyProfileViewController {
                    vc.TableViewLoadData()
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NewCardToCustomLink" {
            
            if isModifying && cardToEdit?.type == "none" {
                let cell = segue.destination as! CardCustomLinkTableViewController

                cell.customExistingIcon = cardToEdit?.img
                cell.customExistingLink = cardToEdit?.url
            }
            
        }
        
    }

    
    
    
}
