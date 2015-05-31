//
//  TDEDebugger.swift
//  TodoEver
//
//  Created by taqun on 2015/05/31.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEDebugger: NSObject {
    
    static func log(message: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            println(message)
        })
    }
    
}
