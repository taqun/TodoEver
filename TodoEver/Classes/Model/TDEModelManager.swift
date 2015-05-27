//
//  TDEModelManager.swift
//  TodoEver
//
//  Created by taqun on 2015/05/27.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEModelManager: NSObject {
    
    static var sharedInstance: TDEModelManager = TDEModelManager()
    
    var isLoggedIn: Bool {
        get {
            if let session = ENSession.sharedSession() {
                return session.isAuthenticated
            } else {
                return false
            }
        }
    }
}
