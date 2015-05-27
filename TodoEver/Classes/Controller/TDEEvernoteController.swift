//
//  TDEEvernoteController.swift
//  TodoEver
//
//  Created by taqun on 2015/05/27.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEEvernoteController: NSObject {
    
    static var sharedInstance: TDEEvernoteController = TDEEvernoteController()
    
    func authenticate(viewController: UIViewController) {
        ENSession.sharedSession().authenticateWithViewController(viewController, preferRegistration: false) { (error) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(TDENotification.COMPLETE_AUTHENTICATION, object: nil)
            }
        }
    }
}
