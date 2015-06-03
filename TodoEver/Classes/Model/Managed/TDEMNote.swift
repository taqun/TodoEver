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
    @NSManaged var content: String
    @NSManaged var usn: NSNumber
    
    @NSManaged var needsToSync: Bool
    @NSManaged var remoteUsn: NSNumber
    
    @NSManaged var tasks: NSMutableSet
    
    
    /*
     * Public Method
     */
    func parseMetaData(metaData: EDAMNoteMetadata) {
        self.title  = metaData.title
        self.guid   = metaData.guid
        
        self.usn = metaData.updateSequenceNum
    }
    
    func appendTasks(tasks: [TDEMTask]) {
        let taskSet = NSMutableSet(array: tasks)
        self.tasks = taskSet
    }
    
    func generateEDAMNote() -> (EDAMNote) {
        var edamNote = EDAMNote()
        edamNote.title      = self.title
        edamNote.guid       = self.guid
        edamNote.content    = self.generateContent()
        
        return edamNote
    }
    
    
    /*
     * Private Method
     */
    func generateContent() -> (String) {
        var writer = ENMLWriter()
        writer.startDocument()
        
        for task in self.orderedTasks {
            writer.writeRawString(task.htmlString)
        }
        
        writer.endDocument()
        
        return writer.contents
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
    
    var isChanged: Bool {
        get {
            if self.content != self.generateContent() {
                return true
            } else {
                return false
            }
        }
    }
    
}
