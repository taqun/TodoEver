//
//  TDENote.swift
//  TodoEver
//
//  Created by taqun on 2015/05/31.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDENote: NSObject {
    
    private var metaData: EDAMNoteMetadata
    
    var tasks: [TDETask]
    
    
    /*
     * Initialize
     */
    init(metaData: EDAMNoteMetadata) {
        self.metaData = metaData
        self.tasks = []
        
        super.init()
    }
    
    
    /*
     * Public Method
     */
    func appendTask(task: TDETask) {
        tasks.append(task)
    }
    
    
    /*
     * Getter, Setter
     */
    var guid: EDAMGuid {
        get {
            return self.metaData.guid
        }
    }
    
    var title: String! {
        get {
            return self.metaData.title
        }
    }
    
}
