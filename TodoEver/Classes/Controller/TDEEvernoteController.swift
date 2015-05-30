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
    
    var queue: NSOperationQueue!
    
    
    /*
     * Initialize
     */
    override init() {
        super.init()
        
        self.queue = NSOperationQueue()
    }
    
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
        var op = TDEListNotesOperation()
        op.addObserver(self, forKeyPath: "finished", options: .New, context: nil)
        self.queue.addOperation(op)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if var op = object as? NSOperation {
            if keyPath == "finished" {
                op.removeObserver(self, forKeyPath: "finished")
            }
        }
    }
}
