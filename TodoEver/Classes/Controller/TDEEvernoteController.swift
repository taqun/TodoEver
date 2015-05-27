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
    
    /*
     * Authentication
     */
    func authenticate(viewController: UIViewController) {
        ENSession.sharedSession().authenticateWithViewController(viewController, preferRegistration: false) { (error) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(TDENotification.COMPLETE_AUTHENTICATION, object: nil)
            }
        }
    }
    
    
    /*
     * Tag
     */
    func getTodoEverTag() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let noteStore = ENSession.sharedSession().primaryNoteStore()
        noteStore.listTagsWithSuccess({ (response) -> Void in
            
            if let tags = response as? [EDAMTag] {
                for tag in tags {
                    if tag.name == "TodoEver" {
                        TDEModelManager.sharedInstance.todoEverTagGuid = tag.guid
                    }
                }
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        }, failure: { (error) -> Void in
            
            println(error)
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        })
    }
    
    func getNotesWithTodoEverTag() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var noteFilter = EDAMNoteFilter()
        noteFilter.tagGuids = ["d2f3f09d-6564-4d39-81b6-ce3fc45c5b6c"]
        
        var resultSpec = EDAMNotesMetadataResultSpec()
        resultSpec.includeTitle = true
        
        let noteStore = ENSession.sharedSession().primaryNoteStore()
        noteStore.findNotesMetadataWithFilter(noteFilter, maxResults: 100, resultSpec: resultSpec, success: { (response) -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if let notes = response as? [EDAMNoteMetadata] {
                TDEModelManager.sharedInstance.notes = notes
            }
            
        }) { (error) -> Void in
            
            println(error)
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}
