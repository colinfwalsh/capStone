//
//  ResultsViewController.swift
//  capStone
//
//  Created by Colin Walsh on 6/12/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView?
    var testArray: [String] = ["Apple", "Candy", "Pear", "Chocolate", "Egg", "Pizza"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    //Abstract this out
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        
        cell.title.text = testArray[indexPath.row]
        cell.subTitle.text = "This is a description of the search result"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

