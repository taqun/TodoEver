//
//  TDEGetAllNoteContentsOperation.swift
//  TodoEver
//
//  Created by taqun on 2015/05/31.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEGetAllNoteContentsOperation: TDEConcurrentOperation {
    
    private var queue: NSOperationQueue
    private var semaphore: dispatch_semaphore_t!
    
    
    /*
     * Initialize
     */
    override init() {
        self.queue = NSOperationQueue()
        
        super.init()
    }
    
    
    /*
     * Public Method
     */
    override func start() {
        super.start()
        
        self.semaphore = dispatch_semaphore_create(0)
        
        let notes = TDEModelManager.sharedInstance.notes
        var operations: [NSOperation] = []
        
        for note in notes {
            println(note.title)
            println(note.needsToSync)
            
            if note.needsToSync {
                var getContentOp = TDEGetNoteContentOperation(guid: note.guid)
                operations.append(getContentOp)
            }
        }
        
        if operations.count == 0 {
            
            self.complete()
            
        } else {
        
            self.queue.addObserver(self, forKeyPath: "operations", options: .New, context: nil)
            self.queue.addOperations(operations, waitUntilFinished: false)
        
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
            self.queue.removeObserver(self, forKeyPath: "operations")
        
            self.complete()
        }
    }
    
    /*
     * KVO
     */
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if var queue = object as? NSOperationQueue {
            if keyPath == "operations" {
                if self.queue.operationCount == 0 && !self.finished {
                    dispatch_semaphore_signal(self.semaphore)
                }
            }
        }
    }
}
