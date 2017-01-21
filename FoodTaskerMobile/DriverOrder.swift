//
//  DriverOrder.swift
//  FoodTaskerMobile
//
//  Created by Daniel Cleaves on 1/20/17.
//  Copyright © 2017 Daniel Cleaves. All rights reserved.
//

import Foundation
import SwiftyJSON

class DriverOrder {
    var id: Int?
    var customerName: String?
    var customerAddress: String?
    var customerAvatar: String?
    var restaurantName: String?
    
    init(json: JSON) {
        self.id = json["id"].int
        self.customerName = json["customer"]["name"].string
        self.customerAddress = json["address"].string
        self.customerAvatar = json["customer"]["avatar"].string
        self.restaurantName = json["restaurant"]["name"].string
    }
}
