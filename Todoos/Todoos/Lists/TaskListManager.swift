//
//  TaskManager.swift
//  siri-todo
//
//  Created by Joas Kramer on 03/04/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

import Foundation

class TaskListManager {
    private var savedLists: [String: [Task]] = [String: [Task]]()
    static let LISTS_KEY = "lists"
    static let GROUP_ID = "group.org.joaskramer.todoos"
    public static let shared = TaskListManager()
    
    let sharedDefaults = UserDefaults(suiteName: TaskListManager.GROUP_ID)
    
    private init() {
        // sharedDefaults?.removeObject(forKey: TaskListManager.LISTS_KEY)
        if let saved = retrieveLists() {
            print(saved)
            savedLists = saved
        }
    }
    
    func lists() -> [String: [Task]] {
        return savedLists
    }
    
    func createList(name: String) {
        let tasks = [Task]()
        /* The shorthand closure returns $1, therefore given merge value will be used when there is a conflict with the keys. */
        print(name)
        savedLists.updateValue(tasks, forKey: name) // merge([name :  tasks], uniquingKeysWith: { $1 })
        print(savedLists)
        saveList(savedLists)
    }
    
    func deleteList(name: String) {
        savedLists = savedLists.filter { (key: String, value: [Task]) in
            return key == name ?
                true :
                false
        }
        saveList(savedLists)
    }
    
    func tasksForList(name listName: String) -> [Task] {
        if let tasks = savedLists[listName] {
            return tasks
        }
        return []
    }
    
    func findList(title listName: String) -> [String: [Task]]? {
        return savedLists.filter { (key: String, value: [Task]) -> Bool in
            return key.contains(listName)
        }
    }
    
    func addTasks(tasks: [Task], to listName: String) -> Bool {
        print("Adding tasks to list")
        print(savedLists)
        guard var savedTasks = savedLists[listName] else {
            return false
        }
        // var savedTasks = savedLists[listName]! // == nil ? [] : savedLists[listName]!
        savedTasks.append(contentsOf: tasks)
        savedLists.updateValue(savedTasks, forKey: listName)
        print("Added tasks to list")
        print(savedLists)
        saveList(savedLists)
        return true
    }
    
    private func archiveLists(_ list: [String: [Task]]) -> Data? {
        do {
            print("Archiving list")
            print(list)
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(list)
            print("Encoded json data")
            print(jsonData)
            return jsonData
//            let archivedObject = try NSKeyedArchiver.archivedData(withRootObject: list)
//            print(archivedObject)
//            return archivedObject
        } catch {
            print("An error occured while archiving")
            return nil
        }
    }
    
    private func saveList(_ list: [String: [Task]]) {
        if let archivedObject = archiveLists(list) {
            print(archivedObject)
            sharedDefaults?.set(archivedObject, forKey: TaskListManager.LISTS_KEY)
            sharedDefaults?.synchronize()
        }
    }
    
    private func retrieveLists() -> [String: [Task]]? {
        do {
            if let unarchivedObject = sharedDefaults?.data(forKey: TaskListManager.LISTS_KEY) {
                print(unarchivedObject)
                let jsonDecoder = JSONDecoder()
                let jsonData = try jsonDecoder.decode([String: [Task]].self, from: unarchivedObject)
                print("Json data decoded")
                print(jsonData)
                print("End of decoded json data")
                return jsonData
            // return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject) as? [String: [Task]]
            } else {
                return nil
            }
        } catch let error  {
            print("Something bad happened while decoding json data")
            print(error)
            return nil
        }
    }
    
    func finishTask(taskTitle: String) {
        if let listName = self.findTaskInList(taskTitle) {
            print("Saved list before setting task completed")
            print(savedLists)
            let list = savedLists[listName]!
//            if let index = list.firstIndex(where: { (taskInList) -> Bool in
//                taskInList.title == taskTitle
//            }) {
//                list.remove(at: index)
            let newList = list.map({ (task) -> Task in
                if task.title == taskTitle {
                    return task.setComplete()
                } else {
                    return task
                }
            })
            savedLists[listName]! = newList
            print("Saved list after setting task completed")
            print(savedLists)
            saveList(savedLists)
//            }
        }
    }
    
//    private func updateSavedLists(changedList: [String]?, listName: String) {
//        savedLists[listName] = changedList
//        sharedDefaults?.set(savedLists, forKey: TaskListManager.LISTS_KEY)
//        sharedDefaults?.synchronize()
//    }
    
    private func findTaskInList(_ taskTitle: String) -> String? {
        for (listName, list) in savedLists {
            if list.contains(where: { (taskInList) -> Bool in
                    return taskInList.title == taskTitle
            }) {
                return listName
            }
        }
        return nil
    }
}
