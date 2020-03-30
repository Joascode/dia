//
//  MenuItem.swift
//  RestaurantApp
//
//  Created by Joas Kramer on 06/02/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

import Foundation

struct MenuItem: Codable {
    var id: Int
    var name: String
    var detailText: String
    var price: Double
    var category: String
    var imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailText = "description"
        case price
        case category
        case imageURL
    }
}

struct MenuItems: Codable {
    let items: [MenuItem]
}
