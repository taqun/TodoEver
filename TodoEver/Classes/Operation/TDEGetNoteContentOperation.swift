//
//  TDEGetNoteContentOperation.swift
//  TodoEver
//
//  Created by taqun on 2015/05/31.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

import SWXMLHash

class TDEGetNoteContentOperation: TDEConcurrentOperation {
    
    private var guid:EDAMGuid
    
    
    /*
     * Initialize
     */
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
        let guid = self.guid as String
        
        noteStore.getNoteContentWithGuid(guid, success: { (response) -> Void in
            
            if var note = TDEModelManager.sharedInstance.getNoteByGuid(self.guid) {

                self.parseContents(note.guid, response: response)
                    
                dispatch_semaphore_signal(semaphore)
                
            } else {
                dispatch_semaphore_signal(semaphore)
            }
            
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
    private func parseContents(guid: EDAMGuid, response: String) {
        var note = TDEModelManager.sharedInstance.getNoteByGuid(guid)
        
        if let data = response.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
            let xml = SWXMLHash.parse(data)
            
            var tasks: [TDEMTask] = []
            let context = note.managedObjectContext

            let todos = xml["en-note"]["div"]
            let count = todos.all.count

            for i in 0..<count {
                var todo = todos[i]
                var task = TDEMTask.MR_createInContext(context) as! TDEMTask
                task.parseData(i, data: todo)
                
                tasks.append(task)
            }
            
            note.content = response
            note.appendTasks(tasks)
            
            note.needsToSync = false
            if note.remoteUsn != 0 {
                note.usn = note.remoteUsn
                note.remoteUsn = 0
            }
            
            println(" note: \(note.title), get contents")
            println("   \(note.isChanged)")
            println("   \(note.content)")
            println("   \(note.generateContent())")
        }
    }
}
