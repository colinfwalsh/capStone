//
//  ResultsViewController.swift
//  capStone
//
//  Created by Colin Walsh on 6/12/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit
import Firebase

class ResultsViewController: UITableViewController, UISearchResultsUpdating, SenderDelegate {
    var tempArray: [String] = []
    var testArray: [String] = ["Apple", "Candy", "Pear", "Chocolate", "Egg", "Pizza"]
    var data: [Any]!
    var delegate: CustomItemDelegate!
    static let identifier = "resultsDataSource"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Abstract this out
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        cell.title.text = "\(data[indexPath.row])"
        cell.subTitle.text = "This is a description of the search result"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didTapMenuItem(indexPath: indexPath, senderIdentifier: ResultsViewController.identifier)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        tempArray = testArray
        if searchController.isActive && !searchController.searchBar.text!.isEmpty {
            testArray = testArray.filter({ item in
                return item.lowercased().contains(searchController.searchBar.text!.lowercased())
            })
            tableView.reloadData()
        }
        testArray = tempArray
    }
    

}

