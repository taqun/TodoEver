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
    
    
    /*
     * Public Method
     */
    func getNoteByGuid(guid: EDAMGuid) -> (TDENote!) {
        var result: TDENote!
        
        for note in self.notes {
            if note.guid == guid {
                result = note
            }
        }
        
        return result
    }
    
    
    /*
     * Getter, Setter
     */
    var isLoggedIn: Bool {
        get {
            if let session = ENSession.sharedSession() {
                return session.isAuthenticated
            } else {
                return false
            }
        }
    }
    
    var todoEverTagGuid: EDAMGuid! {
        set {
            var ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(newValue, forKey: "TodoEverTag")
            ud.synchronize()
        }
        
        get {
            var ud = NSUserDefaults.standardUserDefaults()
            if let guid = ud.objectForKey("TodoEverTag") as? EDAMGuid {
                return guid
            } else {
                return nil
            }
        }
    }
    
    private var _notes: [TDENote]!
    var notes: [TDENote]! {
        set {
            self._notes = newValue
            
            NSNotificationCenter.defaultCenter().postNotificationName(TDENotification.UPDATE_NOTES, object: nil)
        }
        
        get {
            return self._notes
        }
    }
}
