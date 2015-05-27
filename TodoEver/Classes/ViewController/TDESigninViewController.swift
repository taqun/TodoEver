//
//  TDESigninViewController.swift
//  TodoEver
//
//  Created by taqun on 2015/05/27.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDESigninViewController: UIViewController {
    
    @IBOutlet var btnSignin: UIButton!

    
    /*
     * Initialize
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSignin.addTarget(self, action: Selector("signinBtnTouched"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    /*
     * Private Method
     */
    @objc private func signinBtnTouched() {
        TDEEvernoteController.sharedInstance.authenticate(self)
    }
    
    @objc private func completeAuthentication() {
        let storyBoard = UIStoryboard(name: "IndexViewController", bundle: nil)
        let viewController = storyBoard.instantiateInitialViewController() as! TDEIndexViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    /*
     * UIViewController Method
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("completeAuthentication"), name: TDENotification.COMPLETE_AUTHENTICATION, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
