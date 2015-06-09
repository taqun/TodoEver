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
        super.tearDown()
        
        MagicalRecord.cleanUp()
    }
    
}
