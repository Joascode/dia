//
//  TaskDetailViewController.swift
//  siri-todo
//
//  Created by Joas Kramer on 02/04/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

import UIKit
import Eureka

class TaskDetailFormViewController: FormViewController {
    
    public var task: Task!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Basic settings")
            <<< TextRow(){ row in
                row.title = "Task title"
                row.placeholder = "Enter task title here"
                row.value = task.title
            }
            <<< SwitchRow(){
                $0.title = "Task completed"
                $0.value = task.completed
            }
            +++ Section("Extra settings")
            <<< DateRow(){
                $0.title = "Start remember date"
                $0.noValueDisplayText = "No remember date set"
                $0.value = task.dateTime
        }
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
