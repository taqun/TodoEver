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
        resultSpec.includeUpdateSequenceNum = true
        
        let noteStore = ENSession.sharedSession().primaryNoteStore()
        noteStore.findNotesMetadataWithFilter(noteFilter, maxResults: 100, resultSpec: resultSpec, success: { (response) -> Void in
            
            if let noteMetas = response as? [EDAMNoteMetadata] {
                for noteMeta in noteMetas {
                    
                    if let localNote = TDEModelManager.sharedInstance.getNoteByGuid(noteMeta.guid) {
                        if let usn = noteMeta.updateSequenceNum {
                            println(localNote.title)
                            println("   Remote USN: \(usn)")
                            println("   Local USN: \(localNote.usn)")
                            
                            if usn.intValue > localNote.usn.intValue {
                                println("   => \(localNote.title) should be update.")
                                localNote.needsToSync = true
                                localNote.remoteUsn = usn
                            }
                        }
                        
                    } else {
                        var note = TDEMNote.MR_createEntity() as! TDEMNote
                        note.parseMetaData(noteMeta)
                        note.needsToSync = true
                        note.remoteUsn = 0
                    }

                }
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(TDENotification.UPDATE_NOTES, object: nil)
            
            dispatch_semaphore_signal(semaphore)
        
        }) { (error) -> Void in
            
            println(error)
            
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        self.complete()
    }
}
