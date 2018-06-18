//
//  HomeViewController.swift
//  capStone
//
//  Created by Colin Walsh on 5/24/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

protocol SenderDelegate {
    static var identifier: String {get}
}
//TODO: Add seperate files for these
protocol CustomItemDelegate {
    func didTapMenuItem(indexPath: IndexPath, senderIdentifier: String)
}

struct SearchItem {
    let searchTerm: String
    let location: CLLocationCoordinate2D
}
struct User {
    let userName: String
    let recentSearchs: [SearchItem]
    let geoLocation: CLLocationCoordinate2D
    let friends: [User]
}
class HomeViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var searchController: UISearchController? = nil
    let locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet weak var tableView: UITableView!
    var count = 0
    @IBOutlet weak var menuConstraint: NSLayoutConstraint!
    var ref: DatabaseReference!
    let menuDataSource = MenuDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        print(defaults.string(forKey: "name") ?? "NO_NAME")
        menuDataSource.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        tableView.dataSource = menuDataSource
        tableView.delegate = menuDataSource
        ref = Database.database().reference(withPath: "test-items")
        
        menuConstraint.constant = -tableView.frame.width*2
        
        ref.observe(.value, with: {snapshot in
            //Change from init to update with a protocol to control data flow
            self.setupSearchController(with:
                self.initializeSearchController(withData:
                                                snapshot.children.map{$0})
            )
             self.setupSearchBar()
        })
        
    }
    @IBAction func menuTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.menuConstraint.constant = self.menuConstraint.constant != 0 ? 0 : -self.tableView.frame.width*2
            self.view.layoutIfNeeded()
        })
    }
    func initializeSearchController(withData: [Any]) -> ResultsViewController {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "results") as! ResultsViewController
        locationSearchTable.data = withData
        locationSearchTable.delegate = self
        return locationSearchTable
    }
  
    func setupSearchController(with locationSearchTable: ResultsViewController) {
        searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        navigationItem.searchController = searchController
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    func setupSearchBar() {
        let searchBar = searchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
    }
    //Dummy function should be changed
    @IBAction func addItemToDatabase(_ sender: Any) {
        count+=1
        self.ref.child("item\(count)").setValue("New text")
    }
}
//TODO: Also add annnotations and such
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last {
            print("location:: \(location)")
            mapView.setRegion(MKCoordinateRegionMake(location.coordinate, MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

extension HomeViewController: CustomItemDelegate {
    func didTapMenuItem(indexPath: IndexPath, senderIdentifier: String) {
        switch senderIdentifier {
        case ResultsViewController.identifier:
            print("Sending from resultsViewController! Item is \(indexPath.row)")
        default:
            print("Sending from menuDataSource! Item is \(indexPath.row)")
        }
    }
}
