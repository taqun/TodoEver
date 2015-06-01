//
//  TDEMNote.swift
//  TodoEver
//
//  Created by taqun on 2015/06/01.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit
import CoreData

import SWXMLHash

@objc(TDEMNote)
class TDEMNote: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var guid: String
    
    @NSManaged var tasks: NSMutableSet
    
    
    /*
     * Public Method
     */
    func parseMetaData(metaData: EDAMNoteMetadata) {
        self.title  = metaData.title
        self.guid   = metaData.guid
    }
    
    func appendTasks(tasks: [TDEMTask]) {
        let taskSet = NSMutableSet(array: tasks)
        self.tasks = taskSet
    }
    
    
    /*
     * Getter, Setter
     */
    var orderedTasks: [TDEMTask] {
        get {
            if var array = self.tasks.allObjects as? [TDEMTask] {
                array.sort({ $0.index < $1.index })
                return array
            } else {
                return []
            }
        }
    }
    
}
