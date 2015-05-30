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

        var noteFilter = EDAMNoteFilter()
        noteFilter.tagGuids = ["d2f3f09d-6564-4d39-81b6-ce3fc45c5b6c"]
        
        var resultSpec = EDAMNotesMetadataResultSpec()
        resultSpec.includeTitle = true
        
        let noteStore = ENSession.sharedSession().primaryNoteStore()
        noteStore.findNotesMetadataWithFilter(noteFilter, maxResults: 100, resultSpec: resultSpec, success: { (response) -> Void in
            
            if let notes = response as? [EDAMNoteMetadata] {
                TDEModelManager.sharedInstance.notes = notes
            }
            
            self.complete()
        
        }) { (error) -> Void in
            
            println(error)
            
            self.complete()
        }
    }
}
