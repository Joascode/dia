//
//  Categories.swift
//  RestaurantApp
//
//  Created by Joas Kramer on 06/02/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
