//
//  TaskHandler.swift
//  TaskListExtension
//
//  Created by Joas Kramer on 03/04/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

import Intents

class TaskHandler: NSObject, INAddTasksIntentHandling, INSetTaskAttributeIntentHandling {
    
    func handle(intent: INSetTaskAttributeIntent, completion: @escaping (INSetTaskAttributeIntentResponse) -> Void) {
        guard let title = intent.targetTask?.title else {
            completion(INSetTaskAttributeIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        let status = intent.status
        
        if status == .completed {
            TaskListManager.shared.finishTask(taskTitle: title.spokenPhrase)
        }
        
        let response = INSetTaskAttributeIntentResponse(code: .success, userActivity: nil)
        response.modifiedTask = intent.targetTask
        completion(response)
    }
    
    func handle(intent: INAddTasksIntent, completion: @escaping (INAddTasksIntentResponse) -> Void) {
        let taskList = intent.targetTaskList
        
        guard let title = taskList?.title else {
            completion(INAddTasksIntentResponse.init(code: .failure, userActivity: .none))
            return
        }
        
        var spokenTasks = [INTask]()
        if let taskTitles = intent.taskTitles {
            spokenTasks = createTasks(titles: taskTitles)
            let taskListTasks = spokenTasks.map({(task: INTask) in
                return Task(task.title.spokenPhrase, task.temporalEventTrigger?.dateComponentsRange.startDateComponents, false)
            })
            if TaskListManager.shared.addTasks(tasks: taskListTasks, to: title.spokenPhrase) {
                let response = INAddTasksIntentResponse(code: .success, userActivity: nil)
                response.modifiedTaskList = intent.targetTaskList
                response.addedTasks = spokenTasks
                
                completion(response)
            } else {
                let response = INAddTasksIntentResponse(code: .failure, userActivity: nil)
                response.modifiedTaskList = intent.targetTaskList
                completion(response)
            }
        }
    }
    
    func resolveTargetTaskList(for intent: INAddTasksIntent, with completion: @escaping (INTaskListResolutionResult) -> Void) {
        if let targetTaskList = intent.targetTaskList?.title {
            if let lists = TaskListManager.shared.findList(title: targetTaskList.spokenPhrase) {
                if lists.count == 1 {
                    completion(INTaskListResolutionResult.success(with: INTaskList.init(title: INSpeakableString.init(spokenPhrase: Array(lists)[0].key), tasks: [], groupName: nil, createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil)))
                } else {
                    completion(INTaskListResolutionResult.disambiguation(with: disambiguationOptions(tasklists: Array(lists.keys))))
                }
            }
        } else {
            return
        }
    }
    
    private func disambiguationOptions(tasklists: [String]) -> [INTaskList] {
        var taskList = [INTaskList]()
        
        for listName in tasklists.enumerated() {
            taskList.append(INTaskList.init(title: INSpeakableString.init(spokenPhrase: listName.element), tasks: [INTask](), groupName: nil, createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil))
        }
        
        return taskList
    }
    
    private func createTasks(titles taskTitles: [INSpeakableString]) -> [INTask] {
        var tasks = [INTask]()
        
        taskTitles.forEach({ title in
            let task = INTask(title: title, status: .notCompleted, taskType: .completable, spatialEventTrigger: nil, temporalEventTrigger: nil, createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil)
            tasks.append(task)
        })
        
        return tasks
    }
    
//    func handle(intent: INAddTasksIntent, completion: @escaping (INAddTasksIntentResponse) -> Void) {
//        let response = INAddTasksIntentResponse.init(code: INAddTasksIntentResponseCode.ready, userActivity: .none)
//        completion(response)
//    }
//
//    func resolveTaskTitles(for intent: INAddTasksIntent, with completion: @escaping ([INSpeakableStringResolutionResult]) -> Void) {
//
//        if let titles = intent.taskTitles {
//            var tasks: [INSpeakableStringResolutionResult] = [];
//            for title in titles {
//                tasks.append(INSpeakableStringResolutionResult.success(with: title))
//            }
//            completion(tasks)
//        } else {
//            print("Something went wrong assigning titles to tasks")
//        }
//    }
//
//    func resolveTemporalEventTrigger(for intent: INAddTasksIntent, with completion: @escaping (INTemporalEventTriggerResolutionResult) -> Void) {
//        if let date = intent.temporalEventTrigger {
//            completion(INTemporalEventTriggerResolutionResult.success(with: date))
//        }  else {
//            print("Something went wrong assigning date to task")
//        }
//    }
//
//    func resolveTargetTaskList(for intent: INAddTasksIntent, with completion: @escaping (INTaskListResolutionResult) -> Void) {
//        if let taskList = intent.targetTaskList {
//            completion(INTaskListResolutionResult.success(with: taskList))
//        } else {
//            print("Something went wrong assigning tasks to list")
//        }
//    }
}
