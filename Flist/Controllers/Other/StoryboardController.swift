//
//  StoryboardController.swift
//  Flist
//
//  Created by Роман Широков on 17.11.17.
//  Copyright © 2017 Flist. All rights reserved.
//

import Foundation
import UIKit

// Storyboard Utility Controller
class StoryboardController {
    
    
    /**
     - parameter BoardID: The identificator of the board.
     - returns: the initial UIViewController from the given board.
    */
    static func getInitialController(withBoardID: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: withBoardID, bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
    
    
    /**
     - parameters:
        - BoardID: The identificator of the board.
        - controllerID: The identificatior of the desired controller.
     - returns: the UIViewController of the given identificator from the given board.
     */
    static func getController(boardID: String, controllerID: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: boardID, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: controllerID)
    }
    
}
