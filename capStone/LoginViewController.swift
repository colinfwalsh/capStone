//
//  LoginViewController.swift
//  capStone
//
//  Created by Colin Walsh on 6/15/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit
//https://api.yelp.com/v3/businesses/search?term=delis&latitude=40.7128&longitude=-74.0060
class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func submitTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "didLaunch")
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
