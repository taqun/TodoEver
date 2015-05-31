//
//  TDEGetNoteContentOperation.swift
//  TodoEver
//
//  Created by taqun on 2015/05/31.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEGetNoteContentOperation: TDEConcurrentOperation {
    
    private var guid:EDAMGuid
    
    init(guid: EDAMGuid) {
        self.guid = guid
        
        super.init()
    }
   
    override func start() {
        super.start()
        
        let semaphore = dispatch_semaphore_create(0)
        
        let noteStore = ENSession.sharedSession().primaryNoteStore()
        let guid = self.guid as String
        
        noteStore.getNoteContentWithGuid(guid, success: { (response) -> Void in
            
            if var note = TDEModelManager.sharedInstance.getNoteByGuid(self.guid) {
                note.contents = response
            }
            
            dispatch_semaphore_signal(semaphore)
            
        }) { (error) -> Void in
            println(error)
            
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        self.complete()
    }
}
