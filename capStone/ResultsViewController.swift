//
//  ResultsViewController.swift
//  capStone
//
//  Created by Colin Walsh on 6/12/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//
import UIKit
import Firebase

protocol ViewModelProtocol: class {
    associatedtype Element
    var data: Element {get set}
    var didSetData: ((Self) -> ())? {get set}
    init(_ data: Element)
}

struct ResultsObject {
    var title: String
    var items: [Any]
}
final class ResultsViewModel: ViewModelProtocol {
    typealias Element = [ResultsObject]
    
    var data: Element = Element() {
        didSet {
            self.didSetData?(self)
        }
    }
    
    var didSetData: ((ResultsViewModel) -> ())?
    
    required init(_ data: Element) {
        self.data = data
    }
}

class ResultsViewController: UITableViewController, UISearchResultsUpdating, SenderDelegate {
    var tempArray: [String] = []
    var testArray: [String] = ["Apple", "Candy", "Pear", "Chocolate", "Egg", "Pizza"]
    var viewModel = ResultsViewModel([ResultsObject(title: "Test", items: ["test"])]) {
        didSet {
            viewModel.didSetData? = {[weak self] vm in
                guard let `self` = self else {return}
                print(vm)
            }
        }
    }
    var delegate: CustomItemDelegate!
    static let identifier = "resultsDataSource"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //Abstract this out
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data[section].items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        let itemToDisplay = viewModel.data[indexPath.section].items[indexPath.row]
        var textToDisplay = ""
        var subtitleToDisplay = ""
        switch itemToDisplay {
        case let itemToDisplay as YelpBusiness:
            textToDisplay = itemToDisplay.name
            subtitleToDisplay = itemToDisplay.alias
        default:
            textToDisplay = "\(itemToDisplay)"
            subtitleToDisplay = "Placeholder text"
        }
        cell.title.text = textToDisplay
        cell.subTitle.text = subtitleToDisplay
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
