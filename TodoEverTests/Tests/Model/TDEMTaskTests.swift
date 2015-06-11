//
//  TDEMTaskTests.swift
//  TodoEver
//
//  Created by taqun on 2015/06/11.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit
import XCTest

import MagicalRecord
import SWXMLHash

class TDEMTaskTests: XCTestCase {
   
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
    private func createTask() -> (TDEMTask) {
        let context = NSManagedObjectContext.MR_defaultContext()
        let entity = NSEntityDescription.entityForName("TDEMTask", inManagedObjectContext: context)!
        let task = TDEMTask(entity: entity, insertIntoManagedObjectContext: context)
        
        return task
    }
    
    
    /*
     * Tests
     */
    func testCreateEntity() {
        let task = self.createTask()
        XCTAssertNotNil(task)
        XCTAssertEqual(task.index, 0)
        //XCTAssertNil(task.title)
        XCTAssertFalse(task.isChecked)
    }
    
    func testParseData() {
        let xmlString: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
        "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">" +
        "<en-note>" +
            "<div>" +
                "<en-todo checked=\"true\"></en-todo>Task A" +
            "</div>" +
            "<div>" +
                "<en-todo></en-todo>Task B" +
            "</div>" +
        "</en-note>"

        var xml = SWXMLHash.parse(xmlString)
        let todos = xml["en-note"]["div"]
        let count = todos.all.count
        
        var tasks: [TDEMTask] = []
        
        for i in 0..<count {
            var todo = todos[i]
            var task = self.createTask()
            task.parseData(i, data: todo)
            
            tasks.append(task)
        }
        
        XCTAssertEqual(tasks.count, 2)
        
        let firstTask = tasks[0]
        XCTAssertEqual(firstTask.index, 0)
        XCTAssertEqual(firstTask.title, "Task A")
        XCTAssertEqual(firstTask.isChecked, true)
        
        let sencodTask = tasks[1]
        XCTAssertEqual(sencodTask.index, 1)
        XCTAssertEqual(sencodTask.title, "Task B")
        XCTAssertEqual(sencodTask.isChecked, false)
    }
    
    func testHtmlString() {
        let task = self.createTask()
        task.title = "Task A"
        task.isChecked = true
        XCTAssertEqual(task.htmlString, "<div><en-todo checked=\"true\"></en-todo>Task A</div>")
        
        task.title = "Task B"
        task.isChecked = false
        XCTAssertEqual(task.htmlString, "<div><en-todo></en-todo>Task B</div>")
        
    }
}
