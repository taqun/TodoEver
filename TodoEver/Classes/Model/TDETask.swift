//
//  TDETask.swift
//  TodoEver
//
//  Created by taqun on 2015/06/01.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

import SWXMLHash

class TDETask: NSObject {
    
    var title: String!
    var isChecked: Bool = false
    
    /*
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
    <en-note>
        <div>
            <en-todo checked="true"></en-todo>Task A
        </div>
        <div>
            <en-todo></en-todo>Task B
        </div>
        <div>
            <en-todo checked="true"></en-todo>たすくC
        </div>
        <div>
            <en-todo></en-todo>タスクD
        </div>
    </en-note>
    */
    
    func parseData(data: XMLIndexer) {
        self.title = data.element?.text
        
        if var checkedValue = data["en-todo"].element?.attributes["checked"] {
            if checkedValue == "true" {
                self.isChecked = true
            } else {
                self.isChecked = false
            }
        } else {
            self.isChecked = false
        }
    }
    
}
