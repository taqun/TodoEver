//
//  TDEUpdateNoteOperation.swift
//  TodoEver
//
//  Created by taqun on 2015/06/02.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEUpdateNoteOperation: TDEConcurrentOperation {
    
    private var guid: EDAMGuid
    
    private var edamNoteToUpdate: EDAMNote!
    
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
        
        let note = TDEModelManager.sharedInstance.getNoteByGuid(self.guid)
        edamNoteToUpdate = note.generateEDAMNote()
        
        noteStore.updateNote(edamNoteToUpdate, success: { (edamNote) -> Void in
            
            self.updateNote(edamNote)
            
            dispatch_semaphore_signal(semaphore)
            
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
    func updateNote(edamNote: EDAMNote) {
        let note = TDEModelManager.sharedInstance.getNoteByGuid(self.guid)
        
        note.usn = edamNote.updateSequenceNum
        note.content = self.edamNoteToUpdate.content
    }
}
