//
//  TDEMTask.swift
//  TodoEver
//
//  Created by taqun on 2015/06/02.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit
import CoreData

import SWXMLHash

@objc(TDEMTask)
class TDEMTask: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var isChecked: Bool
    @NSManaged var index: Int

    
    /*
     * Public Method
     */
    func parseData(index:Int, data: XMLIndexer) {
        self.index = index
        
        if let titleValue = data.element?.text {
            self.title = titleValue
        }
        
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
    
    
    /*
     * Getter, Setter
     */
    var htmlString: String {
        get {
            if self.isChecked {
                return "<div><en-todo checked=\"\(self.isChecked)\"></en-todo>\(self.title)</div>"
            } else {
                return "<div><en-todo></en-todo>\(self.title)</div>"
            }
        }
    }
}
