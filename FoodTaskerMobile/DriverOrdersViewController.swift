//
//  DriverOrdersViewController.swift
//  FoodTaskerMobile
//
//  Created by Daniel Cleaves on 1/19/17.
//  Copyright © 2017 Daniel Cleaves. All rights reserved.
//

import UIKit

class DriverOrdersViewController: UITableViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var orders = [DriverOrder]()
    let activityIndivator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadReadyOrders()
    }
    
    func loadReadyOrders() {
        Helpers.showActivityIndicator(activityIndivator, self.view)
        APIManager.shared.getDriverOrders { (json) in
            if json != nil {
                self.orders = []
                if let readyOrders = json["orders"].array {
                    for item in readyOrders {
                        let order = DriverOrder(json: item)
                        self.orders.append(order)
                    }
                }
                
                self.tableView.reloadData()
                Helpers.hideActivityIndicator(self.activityIndivator)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverOrdersCell", for: indexPath) as!
        DriverOrderCell
        
        let order = orders[indexPath.row]
        cell.lbRestaurant.text = order.restaurantName
        cell.lbCustomerName.text = order.customerName
        cell.lbCustomerAddress.text = order.customerAddress
        
        cell.imgCustomerAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: order.customerAvatar!)!))
        cell.imgCustomerAvatar.layer.cornerRadius = 50/2
        cell.imgCustomerAvatar.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        self.pickOrder(orderId: order.id!)
    }
    
    private func pickOrder(orderId: Int) {
        APIManager.shared.pickOrder(orderId: orderId) { (json) in
            if let status = json["status"].string {
                
                switch status {
                    
                case "failed":
                    // Show an error alert
                    let alertView = UIAlertController(title: "Error", message: json["error"].string!, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                    
                    alertView.addAction(cancelAction)
                    self.present(alertView, animated: true, completion: nil)
                    
                default:
                    // Show success
                    let alertView = UIAlertController(title: nil, message: "Success!", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Show my map", style: .default, handler: {
                        (action) in
                        self.performSegue(withIdentifier: "CurrentDelivery", sender: self)
                    })
                    
                    alertView.addAction(okAction)
                    self.present(alertView, animated: true, completion: nil)

                }
            }
        }
    }

  
}
