//
//  ViewController.swift
//  Core Data UITableView
//
//  Created by Randall Mardus on 2/12/16.
//  Copyright © 2016 Randall Mardus. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var users = [User]()
    let tableView = UITableView()
    var newNameInput: UITextField?
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    title = "Users"
        edgesForExtendedLayout = UIRectEdge.None
        tableView.frame = view.frame
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("toggleEdit"))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        
        navigationItem.rightBarButtonItem = addButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleEdit() {
        tableView.setEditing(!tableView.editing, animated: true)
        let title = tableView.editing ? "Done" : "Edit"
        navigationItem.leftBarButtonItem?.title = title
    }
    
    func insertNewObject(sender: AnyObject) {
        let newNameAlert = UIAlertController(title: "Add New User", message: "What's the new user's name?", preferredStyle: UIAlertControllerStyle.Alert)
        newNameAlert.addTextFieldWithConfigurationHandler { (alertTextField) -> Void in
            self.newNameInput = alertTextField
    }
        newNameAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        newNameAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: addNewUser))
        presentViewController(newNameAlert, animated: true, completion: nil)
    }
    
    func addNewUser (alert: UIAlertAction!) {
        guard let name = newNameInput?.text else {return}
        
        guard let context = context else {return}
        guard let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as? User else {return}
        
        user.name = name
        
        do {
            try context.save()
        } catch {
            print("There was a problem saving.")
            return
        }
        
        users.append(user)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
}

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            users.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}








