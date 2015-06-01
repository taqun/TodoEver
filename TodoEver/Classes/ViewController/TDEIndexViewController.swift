//
//  TDEIndexViewController.swift
//  TodoEver
//
//  Created by taqun on 2015/05/27.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDEIndexViewController: UITableViewController {

    
    /*
     * Debug
     */
    @IBOutlet var __btnRefresh: UIBarButtonItem!
    @IBOutlet var __btnDelete: UIBarButtonItem!
    
    @objc private func __didBtnRefresh() {
        TDEEvernoteController.sharedInstance.sync()
    }
    
    @objc private func __didBtnDelete() {
        TDEModelManager.sharedInstance.truncate()
    }
    
    
    /*
     * Initialize
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        __btnRefresh.target = self
        __btnRefresh.action = Selector("__didBtnRefresh")
        
        __btnDelete.target = self
        __btnDelete.action = Selector("__didBtnDelete")
    }
    
    
    /*
     * Private Method
     */
    @objc private func noteUpdated() {
        self.tableView.reloadData()
    }
    
    
    /*
     * UIViewController Method
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // navigation bar
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.title = "TodoEver"
        
        // toolbar
        self.navigationController?.toolbarHidden = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("noteUpdated"), name: TDENotification.UPDATE_NOTES, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    /*
     * UITableViewDataSource
     */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let notes = TDEModelManager.sharedInstance.notes {
            return notes.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IndexTableCell", forIndexPath: indexPath) as! UITableViewCell
        
        let note = TDEModelManager.sharedInstance.notes[indexPath.row]
        
        cell.textLabel?.text = note.title

        return cell
    }
    
    /*
     * UITableViewDelegate
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var note = TDEModelManager.sharedInstance.notes[indexPath.row]
        
        let taskListViewController = TDETaskListViewController(noteData: note)
        self.navigationController?.pushViewController(taskListViewController, animated: true)
    }

}
