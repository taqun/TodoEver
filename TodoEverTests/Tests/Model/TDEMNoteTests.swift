//
//  TDEMNoteTests.swift
//  TodoEver
//
//  Created by taqun on 2015/06/09.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit
import XCTest

import MagicalRecord

class TDEMNoteTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        MagicalRecord.setupCoreDataStackWithInMemoryStore()
    }
    
    override func tearDown() {
        MagicalRecord.cleanUp()
        
        super.tearDown()
    }
    
    
    /*
     * Private Method
     */
    private func createNote() -> (TDEMNote) {
        let context = NSManagedObjectContext.MR_defaultContext()
        let entity = NSEntityDescription.entityForName("TDEMNote", inManagedObjectContext: context)!
        let note = TDEMNote(entity: entity, insertIntoManagedObjectContext: context)
        
        return note
    }
    
    private func createTask() -> (TDEMTask) {
        let context = NSManagedObjectContext.MR_defaultContext()
        let entity = NSEntityDescription.entityForName("TDEMTask", inManagedObjectContext: context)!
        let task = TDEMTask(entity: entity, insertIntoManagedObjectContext: context)
        
        return task
    }
    
    private func createTasks() -> ([TDEMTask]) {
        var tasks: [TDEMTask] = []
        
        var task1 = self.createTask()
        task1.index = 2
        task1.title = "Task3"
        task1.isChecked = false
        tasks.append(task1)
        
        var task2 = self.createTask()
        task2.index = 1
        task2.title = "Task2"
        task2.isChecked = true
        tasks.append(task2)
        
        var task3 = self.createTask()
        task3.index = 0
        task3.title = "Task1"
        task3.isChecked = true
        tasks.append(task3)
        
        return tasks
    }
    
    
    /*
     * Tests
     */
    func testCreateEntity() {
        let note = self.createNote()
        XCTAssertNotNil(note)
    }
    
    func testParseMetaData() {
        let metaData = EDAMNoteMetadata()
        metaData.title              = "note title"
        metaData.guid               = "note guid"
        metaData.updateSequenceNum  = 123
        
        let note = self.createNote()
        note.parseMetaData(metaData)
        
        XCTAssertEqual(note.title, "note title")
        XCTAssertEqual(note.guid, "note guid")
        XCTAssertEqual(note.usn, 123)
    }
    
    func testAppendTasks() {
        let tasks = self.createTasks()  // [2, 1, 0]
        
        let note = self.createNote()
        note.appendTasks(tasks)         // [0, 1, 2]
        
        XCTAssertEqual(note.orderedTasks[0], tasks[2])
        XCTAssertEqual(note.orderedTasks[1], tasks[1])
        XCTAssertEqual(note.orderedTasks[2], tasks[0])
    }
    
    func testAddTask() {
        let tasks = self.createTasks()
        
        let note = self.createNote()
        note.appendTasks(tasks)
        
        var task4 = self.createTask()
        task4.index = 3
        task4.title = "Task4"
        task4.isChecked = false
        
        note.addTask(task4)
        
        XCTAssertEqual(note.orderedTasks[3], task4)
    }
    
    func testRemoveTask() {
        let tasks = self.createTasks()  // [2, 1, 0]
        
        let note = self.createNote()
        note.appendTasks(tasks)         // [0, 1, 2]
        note.removeTask(1)              // [0, 2]
        
        XCTAssertEqual(note.orderedTasks[0], tasks[2])
        XCTAssertEqual(note.orderedTasks[1], tasks[0])
    }
    
}
