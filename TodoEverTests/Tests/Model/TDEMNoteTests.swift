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
    
    
    /*
     * Tests
     */
    func testCreateEntity() {
        let note = self.createNote()
        XCTAssertNotNil(note, "Failed to create TDEMNote")
    }
    
}
