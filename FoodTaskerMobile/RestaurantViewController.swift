//
//  RestaurantViewController.swift
//  FoodTaskerMobile
//
//  Created by Daniel Cleaves on 1/10/17.
//  Copyright © 2017 Daniel Cleaves. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {

    @IBOutlet weak var searchRestaurant: UISearchBar!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var tbvRestaurant: UITableView!
    
    var restaurants = [Restaurant]()
    var filterRestaurants = [Restaurant]()
    
    let activityIndicator = UIActivityIndicatorView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         if self.revealViewController() != nil {

       menuBarButton.target = self.revealViewController()
        menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        loadRestaurants()
    }
    
    func loadRestaurants() {
        Helpers.showActivityIndicator(activityIndicator, view)
        APIManager.shared.getRestaurants { (json) in
            
            if json != nil {
                self.restaurants = []
                if let listRes = json["restaurants"].array {
                    for item in listRes {
                        let restaurant = Restaurant(json : item)
                        self.restaurants.append(restaurant)
                    }
                    self.tbvRestaurant.reloadData()
                    Helpers.hideActivityIndicator(self.activityIndicator)
                }
            }
        }

    }
    
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MealList" {
            let controller = segue.destination as! MealListTableViewController
            controller.restaurant = restaurants[(tbvRestaurant.indexPathForSelectedRow?.row)!]
        }
    }
}

extension RestaurantViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterRestaurants = self.restaurants.filter({ (res: Restaurant) -> Bool in
            return res.name?.lowercased().range(of: searchText.lowercased()) != nil
        })
        self.tbvRestaurant.reloadData()
    }
}

extension RestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchRestaurant.text != "" {
            return self.filterRestaurants.count
        }
        return self.restaurants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantViewCell
        
        let restaurant: Restaurant
        
        if searchRestaurant.text != "" {
            restaurant = filterRestaurants[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        
        cell.lbRestaurantName.text = restaurant.name!
        cell.lbRestaurantAddress.text = restaurant.address!
        
        if let logoName = restaurant.logo {
            let url = "\(logoName)"
            Helpers.loadImage(cell.imgRestaurantLogo, "\(logoName)")
        }
        

        return cell
    }
}
