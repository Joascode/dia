//
//  TaskListTableViewController.swift
//  Todoos
//
//  Created by Joas Kramer on 04/04/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    
    var taskLists: [String: [Task]] = [String: [Task]]();

    override func viewDidLoad() {
        super.viewDidLoad()

        self.taskLists = TaskListManager.shared.lists()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.taskLists = TaskListManager.shared.lists()
        print("Kom ik hier?")
        print(taskLists)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("In view did appear dan?")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("Kom ik hier?")
        print(self.taskLists)
        return self.taskLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = Array(self.taskLists)[indexPath.row].key

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tasklistDetailsSegue" {
            if let viewController = segue.destination as? TaskTableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    let tasks = Array(self.taskLists)[indexPath.row].value
                    print(tasks)
                    print(self.taskLists)
                    viewController.tasks = tasks
                }
            }
        }

    }

}
