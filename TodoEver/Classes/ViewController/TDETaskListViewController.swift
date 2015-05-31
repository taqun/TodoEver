//
//  TDETaskListViewController.swift
//  TodoEver
//
//  Created by taqun on 2015/05/30.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDETaskListViewController: UITableViewController {
    
    private var noteData: TDENote!
    
    
    /*
     * Initialize
     */
    init(noteData: TDENote) {
        super.init(style: .Plain)
        
        self.noteData = noteData
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init!(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TaskTableCell")
    }
    
    
    /*
     * UIViewController Method
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.noteData.title
    }

    
    /*
     * UITableViewDataSource
     */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteData.tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskTableCell", forIndexPath: indexPath) as! UITableViewCell
        
        let task = self.noteData.tasks[indexPath.row]
        
        cell.textLabel?.text = task.title
        if task.isChecked {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
}
