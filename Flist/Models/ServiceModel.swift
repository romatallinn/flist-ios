//
//  ProfileModel.swift
//  Flist
//
//  Created by Роман Широков on 05.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//


import Foundation
import Firebase
import FirebaseDatabase

class ServiceModel {
    
    static var services: [ ServiceListElement ] = [
        
        ServiceListElement(name: "Other",            shortcut: "none",         icon: #imageLiteral(resourceName: "other"),        link: ""),                            // 0 - none
        ServiceListElement(name: "Phone Number",     shortcut: "phone",        icon: #imageLiteral(resourceName: "phone"),        link: "tel:"),                        // 1 - phone
        ServiceListElement(name: "Facebook",         shortcut: "fb",           icon: #imageLiteral(resourceName: "fb"),        link: "https://facebook.com"),        // 2 - facebook
        ServiceListElement(name: "Twitter",          shortcut: "tw",           icon: #imageLiteral(resourceName: "tw"),        link: "https://twitter.com"),         // 3 - twitter
        ServiceListElement(name: "YouTube",          shortcut: "yt",           icon: #imageLiteral(resourceName: "yt"),        link: "https://youtube.com"),         // 4 - youtube
        ServiceListElement(name: "VKontakte",        shortcut: "vk",           icon: #imageLiteral(resourceName: "vk"),        link: "https://vk.com"),              // 5 - vkontakte
        ServiceListElement(name: "LiveJournal",      shortcut: "lj",           icon: #imageLiteral(resourceName: "lj"),        link: "https://livejournal.com"),     // 6 - livejournal
        ServiceListElement(name: "Badoo",            shortcut: "badoo",        icon: #imageLiteral(resourceName: "badoo"),        link: "https://badoo.com"),           // 7 - badoo
        ServiceListElement(name: "Instagram",        shortcut: "insta",        icon: #imageLiteral(resourceName: "insta"),        link: "https://instagram.com"),       // 8 - instagram
        ServiceListElement(name: "Snapchat",         shortcut: "snap",         icon: #imageLiteral(resourceName: "snap"),        link: "https://snapchat.com"),        // 9 - snapchat
        ServiceListElement(name: "LinkedIn",         shortcut: "in",           icon: #imageLiteral(resourceName: "in"),        link: "https://linkedin.com"),        // 10 - linkedin
        ServiceListElement(name: "MySpace",          shortcut: "myspace",      icon: #imageLiteral(resourceName: "myspace"),        link: "https://myspace.com"),         // 11 - myspace
        ServiceListElement(name: "Odnoklassniki",    shortcut: "ok",           icon: #imageLiteral(resourceName: "ok"),        link: "https://ok.ru"),               // 12 - odnoklassniki
        ServiceListElement(name: "Steam",            shortcut: "steam",        icon: #imageLiteral(resourceName: "steam"),        link: "https://steam.com"),           // 13 - steam
        ServiceListElement(name: "Pinterest",        shortcut: "pinterest",    icon: #imageLiteral(resourceName: "pinterest"),        link: "https://pinterest.com"),       // 14 - pinterest
        ServiceListElement(name: "Google+",          shortcut: "google+",      icon: #imageLiteral(resourceName: "gp"),        link: "https://plus.google.com"),     // 15 - google+
        ServiceListElement(name: "Flickr",           shortcut: "flickr",       icon: #imageLiteral(resourceName: "flickr"),        link: "https://flickr.com"),          // 16 - flickr
        ServiceListElement(name: "AskFm",            shortcut: "askfm",        icon: #imageLiteral(resourceName: "askfm"),        link: "https://askfm.com"),           // 17 - askfm
    
        
    ]
    
    static let model = ServiceModel()

    static func loadServices(completionHandler: @escaping (()->())) {


        NetworkLayer.profile.loadCardTypes { (dict) in

            guard let dict = dict else { return }

            var els = [ServiceListElement]()

            for (key, value) in dict {

                var val = value as! [String: Any]
                
                loadIconsForServices(type: key as! String) {
                    (img) in
                    
                    let service = ServiceListElement(name: val["name"] as! String, shortcut: key as! String, icon: img, link: val["link"] as! String )
                    els.append(service)
                    
                    if els.count == dict.count {
                        services = els
                        completionHandler()
                    }
                }
            }

        }

    }
    
    private static func loadIconsForServices(type: String, completionHandler: @escaping ((UIImage)->())) {
        
        NetworkLayer.profile.loadIconsForDefaultTypes(type: type, completionHandler: { (data, error) in
        
            var img = #imageLiteral(resourceName: "other")
            
            if let dt = data {
                img = UIImage(data: dt) ?? #imageLiteral(resourceName: "other")
            }
            
            completionHandler(img)
            
//            for i in 0...services.count {
//                if services[i].shortcut == type {
//                    services[i].icon = img
//                    completionHandler()
//                }
//            }
        
        })
        
    }
    
    static func getTypeByShortcut(_ shortcut: String) -> ServiceListElement {
        
        for elem in self.services {
            if (elem.shortcut == shortcut) {
                return elem
            }
        }
        
        return self.services[0]
    }
    
    
    
}
