//
//  TDEGetNoteContentOperation.swift
//  TodoEver
//
//  Created by taqun on 2015/05/31.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

import SWXMLHash

class TDEGetNoteContentOperation: TDEConcurrentOperation {
    
    private var guid:EDAMGuid
    
    
    /*
     * Initialize
     */
    init(guid: EDAMGuid) {
        self.guid = guid
        
        super.init()
    }
    
    
    /*
     * Public Method
     */
    override func start() {
        super.start()
        
        let semaphore = dispatch_semaphore_create(0)
        
        let noteStore = ENSession.sharedSession().primaryNoteStore()
        let guid = self.guid as String
        
        noteStore.getNoteContentWithGuid(guid, success: { (response) -> Void in
            
            if var note = TDEModelManager.sharedInstance.getNoteByGuid(self.guid) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    self.parseContents(note, response: response)
                    
                    dispatch_semaphore_signal(semaphore)
                })
                
            } else {
                dispatch_semaphore_signal(semaphore)
            }
            
        }) { (error) -> Void in
            println(error)
            
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        self.complete()
    }
    
    /*
     * Private Method
     */
    private func parseContents(note: TDENote, response: String) {
        if let data = response.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
            let xml = SWXMLHash.parse(data)
            
            let todos = xml["en-note"]["div"]
            for todo in todos {
                var task = TDETask()
                task.parseData(todo)
                
                note.appendTask(task)
            }
        }
    }
}
