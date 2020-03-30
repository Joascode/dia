//
//  Task.swift
//  Todoos
//
//  Created by Joas Kramer on 09/04/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

import Foundation

struct Task: Encodable, Decodable {
    var title: String;
    var dateTime: Date?;
    var completed = false;
    
    enum CodingKeys: String, CodingKey {
        case title
        case dateTime
        case completed
    }
    
    init(_ title: String, _ dateTime: DateComponents?, _ completed: Bool = false) {
        self.title = title
        self.dateTime = dateTime?.date
        self.completed = completed
    }
    
    mutating func setCompleted() {
        completed = true
    }
    
    func setComplete() -> Task {
        var copy = self
        copy.setCompleted()
        return copy
    }
    
    //MARK: - NSCoding -
    init(from decoder: Decoder) throws {
//        title = decoder.decodeObject(forKey: "title") as! String
//        if aDecoder.containsValue(forKey: "dateTime") {
//            dateTime = aDecoder.decodeObject(forKey: "dateTime") as! DateComponents
//        }
//        completed = aDecoder.decodeBool(forKey: "completed")
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        if values.contains(.dateTime) {
            let dateString = try values.decode(String.self, forKey: .dateTime)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let s = dateFormatter.date(from: dateString)
            dateTime = s
        }
        
        // dateTime = try values.decode(DateComponents.self, forKey: .dateTime)
        completed = try values.decode(Bool.self, forKey: .completed)
        //String to Date Convert
    }
    
    func encode(to encoder: Encoder) {
        //CONVERT FROM NSDate to String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        do {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        if self.dateTime != nil {
            let dateString = dateFormatter.string(from: self.dateTime!)
            try container.encode(dateString, forKey: .dateTime)
        }
        try container.encode(completed, forKey: .completed)
        } catch {
            print("Something bad happened while encoding")
        }
//        if dateTime != nil {
//            aCoder.encode(dateTime, forKey: "dateTime")
//        }
//        aCoder.encode(completed, forKey: "completed")
    }
}
