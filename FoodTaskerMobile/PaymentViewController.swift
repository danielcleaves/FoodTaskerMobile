//
//  PaymentViewController.swift
//  FoodTaskerMobile
//
//  Created by Daniel Cleaves on 1/12/17.
//  Copyright © 2017 Daniel Cleaves. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController {

    @IBOutlet weak var cardTextField: STPPaymentCardTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func placeOrder(_ sender: Any) {
        APIManager.shared.getLatestOrder { (json) in
            
            if json["order"]["status"] == nil || json["order"]["status"] == "Delivered" {
                // Processing the payment and create an Order
                
                let card = self.cardTextField.cardParams
                
                STPAPIClient.shared().createToken(withCard: card, completion: { (token, error) in
                    if let myError = error {
                        print("Error: ", myError)
                    } else if let stripeToken = token {
                        APIManager.shared.createOrder(stripeToken: stripeToken.tokenId, completionHandler: { (json) in
                            Tray.currentTray.reset()
                            self.performSegue(withIdentifier: "ViewOrder", sender: self)
                        })
                    }
                })
                
            } else {
                // Show an alert message
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                let okAction = UIAlertAction(title: "Go to Order", style: .default, handler: {(action)
                    in
                    self.performSegue(withIdentifier: "View Order", sender: self)
                })
                let alertView = UIAlertController(title: "Already Ordered?", message: "Your current order is not completed", preferredStyle: .alert)
                
                alertView.addAction(okAction)
                alertView.addAction(cancelAction)
                
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
}
