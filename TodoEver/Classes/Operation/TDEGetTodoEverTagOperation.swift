//
//  TDEGetTodoEverTagOperation.swift
//  TodoEver
//
//  Created by taqun on 2015/05/30.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEGetTodoEverTagOperation: TDEConcurrentOperation {
    
    override func start() {
        super.start()
        
        let semaphore = dispatch_semaphore_create(0)
        
        let noteStore = ENSession.sharedSession().primaryNoteStore()
        noteStore.listTagsWithSuccess({ (response) -> Void in

            if let tags = response as? [EDAMTag] {
                for tag in tags {
                    if tag.name == "TodoEver" {
                        TDEModelManager.sharedInstance.todoEverTagGuid = tag.guid
                    }
                }
            }
            
            dispatch_semaphore_signal(semaphore)
            
        }, failure: { (error) -> Void in
            println(error)
            
            dispatch_semaphore_signal(semaphore)
        })
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        self.complete()
    }
}
