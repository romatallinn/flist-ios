//
//  ProfileCardDescriptionPopupViewController.swift
//  Flist
//
//  Created by Roman Sirokov on 12/02/2019.
//  Copyright © 2019 Flist. All rights reserved.
//

import UIKit

class ProfileCardDescriptionPopupViewController: UIViewController {

    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.lightGray.cgColor
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.view.frame
        rectShape.position = self.view.layer.position
        rectShape.path = UIBezierPath(roundedRect: popupView.bounds, byRoundingCorners: [.topRight , .topLeft, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath

        popupView.layer.mask = rectShape
        
        self.view.bringSubviewToFront(popupView)
        
    }
    
    @IBAction func CancelPopupAction(_ sender: Any) {
        self.dismiss(animated: false)
    }
    

}
