//
//  MealViewCell.swift
//  FoodTaskerMobile
//
//  Created by Daniel Cleaves on 1/14/17.
//  Copyright © 2017 Daniel Cleaves. All rights reserved.
//

import UIKit

class MealViewCell: UITableViewCell {

    @IBOutlet weak var imgMealImage: UIImageView!
    @IBOutlet weak var lbMealPrice: UILabel!
    @IBOutlet weak var lbMealShortDescription: UILabel!
    @IBOutlet weak var lbMealName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
