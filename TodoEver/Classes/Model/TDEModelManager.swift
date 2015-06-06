//
//  TDEModelManager.swift
//  TodoEver
//
//  Created by taqun on 2015/05/27.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

import MagicalRecord

class TDEModelManager: NSObject {
    
    static var sharedInstance: TDEModelManager = TDEModelManager()
    
    
    /*
     * Public Method
     */
    func getNotesInDefaultContext() -> ([TDEMNote]) {
        let context = NSManagedObjectContext.MR_defaultContext()
        
        if let notes = TDEMNote.MR_findAllInContext(context) as? [TDEMNote] {
            return notes
        } else {
            return []
        }
    }
    
    func getNoteByGuid(guid: EDAMGuid) -> (TDEMNote!) {
        let predicate = NSPredicate(format: "guid = %@", guid)
        let context = NSManagedObjectContext.MR_defaultContext()
        
        if let notes = TDEMNote.MR_findAllWithPredicate(predicate, inContext: context) as? [TDEMNote] {
            if notes.count > 0 {
                return notes[0]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    
    /*
     * CoreData
     */
    func save() {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func truncate() {
        TDEMNote.MR_truncateAll()
        
        self.save()
        
        NSNotificationCenter.defaultCenter().postNotificationName(TDENotification.UPDATE_NOTES, object: nil)
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
    
    var notes: [TDEMNote] {
        get {
            if let notes = TDEMNote.MR_findAll() as? [TDEMNote] {
                return notes
            } else {
                return []
            }
        }
    }
}
