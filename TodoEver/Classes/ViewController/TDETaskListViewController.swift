//
//  TDETaskListViewController.swift
//  TodoEver
//
//  Created by taqun on 2015/05/30.
//  Copyright (c) 2015年 envoixapp. All rights reserved.
//

import UIKit

class TDETaskListViewController: UITableViewController {
    
    private var noteData: TDEMNote!
    
    
    /*
     * Initialize
     */
    init(noteData: TDEMNote) {
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
     * Private Method
     */
    
    @objc private func addTask() {
        var alertController = UIAlertController(title: "Add new task", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let textFields = alertController.textFields as? [UITextField] {
                if textFields.count > 0 {
                    let textField = textFields[0]
                    
                    if var task = TDEMTask.MR_createEntity() as? TDEMTask {
                        task.title = textField.text
                        task.index = self.noteData.tasks.count
                        
                        println(task.title)
                        println(task.index)
                        
                        self.noteData.addTask(task)
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
        }
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }
    }
    
    
    /*
     * UIViewController Method
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.noteData.title
        
        let btnAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addTask"))
        self.navigationItem.rightBarButtonItem = btnAdd
    }

    
    /*
     * UITableViewDataSource
     */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteData.orderedTasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskTableCell", forIndexPath: indexPath) as! UITableViewCell
        
        let task = self.noteData.orderedTasks[indexPath.row]
        
        cell.textLabel?.text = task.title
        if task.isChecked {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    
    /*
     * UITableViewDelegate
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var task = self.noteData.orderedTasks[indexPath.row]
        task.isChecked = !task.isChecked
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
}
