//
//  DriverOrderCell.swift
//  FoodTaskerMobile
//
//  Created by Daniel Cleaves on 1/20/17.
//  Copyright © 2017 Daniel Cleaves. All rights reserved.
//

import UIKit

class DriverOrderCell: UITableViewCell {
    @IBOutlet weak var lbCustomerAddress: UILabel!
    @IBOutlet weak var lbCustomerName: UILabel!
    @IBOutlet weak var imgCustomerAvatar: UIImageView!
    @IBOutlet weak var lbRestaurant: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
