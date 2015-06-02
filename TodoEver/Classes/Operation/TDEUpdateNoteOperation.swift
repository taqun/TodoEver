//
//  TDEUpdateNoteOperation.swift
//  TodoEver
//
//  Created by taqun on 2015/06/02.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEUpdateNoteOperation: TDEConcurrentOperation {
    
    private var note: TDEMNote
    
    init(note: TDEMNote) {
        self.note = note
        
        super.init()
    }
    
    /*
     * Public Method
     */
    override func start() {
        super.start()
        
        let semaphore = dispatch_semaphore_create(0)
        
        let noteStore = ENSession.sharedSession().primaryNoteStore()
        var edamNote = note.generateEDAMNote()
        
        noteStore.updateNote(edamNote, success: { (edamNote) -> Void in
            
            dispatch_semaphore_signal(semaphore)
            
        }) { (error) -> Void in
            println(error)
            
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        self.complete()
    }
    
}
