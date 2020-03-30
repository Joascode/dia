//
//  TaskListHandler.swift
//  TaskListExtension
//
//  Created by Joas Kramer on 03/04/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

import Intents
import Foundation

class TaskListHandler: NSObject, INCreateTaskListIntentHandling {
//    func handle(intent: INCreateTaskListIntent, completion: @escaping (INCreateTaskListIntentResponse) -> Void) {
//        let response = INCreateTaskListIntentResponse(code: .failure, userActivity: .none)
//        completion(response)
//    }
    
    func handle(intent: INCreateTaskListIntent, completion: @escaping (INCreateTaskListIntentResponse) -> Void) {
        guard let title = intent.title  else {
            completion(INCreateTaskListIntentResponse(code: .failure, userActivity: .none))
            return
        }
        
        TaskListManager.shared.createList(name: title.spokenPhrase)
        
        var spokenTasks = [INTask]()
        if let taskTitles = intent.taskTitles {
            spokenTasks = createTasks(titles: taskTitles)
            let taskListTasks = spokenTasks.map({(task: INTask) in
                return Task(task.title.spokenPhrase, task.temporalEventTrigger?.dateComponentsRange.startDateComponents, false)
            })
            TaskListManager.shared.addTasks(tasks: taskListTasks, to: title.spokenPhrase)
        }
        
        let response = INCreateTaskListIntentResponse(code: .success, userActivity: .none)
        response.createdTaskList = INTaskList(title: title, tasks: spokenTasks, groupName: nil, createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil)
        
        completion(response)
    }
    
    private func createTasks(titles taskTitles: [INSpeakableString]) -> [INTask] {
        var tasks = [INTask]()
        
        taskTitles.forEach({ title in
            let task = INTask(title: title, status: .notCompleted, taskType: .completable, spatialEventTrigger: nil, temporalEventTrigger: nil, createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil)
            tasks.append(task)
        })
        
        return tasks
    }
}
