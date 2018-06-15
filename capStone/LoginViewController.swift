//
//  LoginViewController.swift
//  capStone
//
//  Created by Colin Walsh on 6/15/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func submitTapped(_ sender: Any) {
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
