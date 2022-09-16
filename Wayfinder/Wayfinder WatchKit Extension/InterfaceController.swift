//
//  InterfaceController.swift
//  Wayfinder WatchKit Extension
//
//  Created by Kevin Lieser on 08.09.22.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        presentController(withName: "WatchFaceController", context: nil)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}
