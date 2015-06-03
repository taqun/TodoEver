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
    
    private var queue: NSOperationQueue!
    
    private var isSyncing: Bool = false
    private var isUpdating: Bool = false
    
    
    /*
     * Initialize
     */
    override init() {
        super.init()
        
        self.queue = NSOperationQueue()
        self.queue.maxConcurrentOperationCount = 4
        self.queue.addObserver(self, forKeyPath: "operations", options: .New, context: nil)
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
     * Sync
     */
    func sync() {
        TDEDebugger.log("==============")
        TDEDebugger.log("sync")
        TDEDebugger.log("==============")
        
        self.isSyncing = true
        
        self.getNotesWithTodoEverTag()
    }
    
    private func syncComplete() {
        self.isSyncing = false
        
        self.update()
    }
    
    
    /*
     * Update
     */
    func update() {
        self.isUpdating = true
        
        self.updateNotes()
    }
    
    private func updateComplete() {
        self.isUpdating = false
    }
    
    
    /*
     * Notes
     */
    private func getNotesWithTodoEverTag() {
        var operations: [NSOperation] = []
        
        var listOp = TDEListNotesOperation()
        operations.append(listOp)
        
        if TDEModelManager.sharedInstance.todoEverTagGuid == nil {
            var getTagOp = TDEGetTodoEverTagOperation()
            operations.append(getTagOp)
            listOp.addDependency(getTagOp)
        }
        
        var getAllNoteContentsOp = TDEGetAllNoteContentsOperation()
        operations.append(getAllNoteContentsOp)
        getAllNoteContentsOp.addDependency(listOp)
        
        self.queue.addOperations(operations, waitUntilFinished: false)
    }
    
    private func updateNotes() {
        let notes = TDEModelManager.sharedInstance.notes
        var operations: [NSOperation] = []
        
        for note in notes {
            if note.isChanged {
                var op = TDEUpdateNoteOperation(guid: note.guid)
                operations.append(op)
            }
        }
        
        self.queue.addOperations(operations, waitUntilFinished: false)
    }
    
    
    /*
     * KVO
     */
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if var queue = object as? NSOperationQueue {
            if keyPath == "operations" {
                TDEDebugger.log("queue remaining = \(self.queue.operationCount)")
                
                if self.queue.operationCount == 0 {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if self.isSyncing {
                            self.syncComplete()
                        }
                        
                        if self.isUpdating {
                            self.updateComplete()
                        }
                    })
                }
            }
        }
    }

}
