//
//  TDEListNotesOperation.swift
//  TodoEver
//
//  Created by taqun on 2015/05/30.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEListNotesOperation: TDEConcurrentOperation {
    
    override func start() {
        super.start()
        
        let semaphore = dispatch_semaphore_create(0)

        var noteFilter = EDAMNoteFilter()
        noteFilter.tagGuids = [TDEModelManager.sharedInstance.todoEverTagGuid]
        
        var resultSpec = EDAMNotesMetadataResultSpec()
        resultSpec.includeTitle = true
        
        let noteStore = ENSession.sharedSession().primaryNoteStore()
        noteStore.findNotesMetadataWithFilter(noteFilter, maxResults: 100, resultSpec: resultSpec, success: { (response) -> Void in
            
            var notes: [TDENote] = []
            
            if let noteMetas = response as? [EDAMNoteMetadata] {
                for noteMetaData in noteMetas {
                    var note = TDENote(metaData: noteMetaData)
                    notes.append(note)
                }
                
                TDEModelManager.sharedInstance.notes = notes
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
