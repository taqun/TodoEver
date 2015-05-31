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
    
    var contents: String!
    
    /*
     * Initialize
     */
    init(metaData: EDAMNoteMetadata) {
        self.metaData = metaData
        
        super.init()
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
