//
//  IntentHandler.swift
//  TaskListExtension
//
//  Created by Joas Kramer on 03/04/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any? {
        if intent is INCreateTaskListIntent {
            return TaskListHandler()
        }
        
        if intent is INAddTasksIntent {
            return TaskHandler()
        }
        if intent is INSetTaskAttributeIntent {
            return TaskHandler()
        }
        return .none
    }
}
