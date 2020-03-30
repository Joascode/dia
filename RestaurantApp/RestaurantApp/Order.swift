//
//  Orders.swift
//  RestaurantApp
//
//  Created by Joas Kramer on 06/02/2019.
//  Copyright © 2019 Joas Kramer. All rights reserved.
//

struct Order {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
