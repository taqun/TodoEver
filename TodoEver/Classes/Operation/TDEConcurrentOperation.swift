//
//  TDEConcurrentOperation.swift
//  TodoEver
//
//  Created by taqun on 2015/05/30.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEConcurrentOperation: NSOperation {
    
    
    /*
     * Public Method
     */
    override func start() {
        self.executing = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    
    /*
     * Internal Method
     */
    internal func complete() {
        self.executing = false
        self.finished = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    /*
     * Getter, Setter
     */
    private var _asynchronous: Bool = true
    private var _executing: Bool    = false
    private var _finished: Bool     = false
    
    override var asynchronous: Bool {
        get {
            return _asynchronous
        }
    }
    
    override var executing: Bool {
        get {
            return _executing
        }
        
        set {
            willChangeValueForKey("executing")
            _executing = newValue
            didChangeValueForKey("executing")
        }
    }
    
    override var finished: Bool {
        get {
            return _finished
        }
        
        set {
            willChangeValueForKey("finished")
            _finished = newValue
            didChangeValueForKey("finished")
        }
    }
    
}
