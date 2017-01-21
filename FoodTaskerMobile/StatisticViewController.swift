//
//  StatisticViewController.swift
//  FoodTaskerMobile
//
//  Created by Daniel Cleaves on 1/20/17.
//  Copyright © 2017 Daniel Cleaves. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {
    @IBOutlet weak var menuBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }

}
