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
        menuDataSource.delegate = self

        // All this should be in it's own method
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        //This could possibly be set with a viewmodel as well. I wonder if this could be used to abstract the embeded datasource?
        tableView.dataSource = menuDataSource
        tableView.delegate = menuDataSource
        //This is just a test for firebase - need to fix this
        ref = Database.database().reference(withPath: "test-items")
        //This is setting the left menu so it doesn't show up on initial load
        menuConstraint.constant = -tableView.frame.width*2
        /* This calls an observation from the server and initializes the search controller
           with the data from the server
        */
        let dummyChacheData = ["Cached item","Cached item"]
        let resultsSearchController = self.initializeSearchController(withData: [ResultsObject(title: "Test", items: ["Other test"])])
        self.setupSearchController(with: resultsSearchController)
        self.setupSearchBar()
        ref.observe(.value, with: {snapshot in
            //This will not work, appending this data to the array in the does not make the data reactive. Maybe two arrays?  Staging and live, change state based off query
            resultsSearchController.data.append(ResultsObject(title: "SnapshotChildren", items: snapshot.children.allObjects))
        })
        /*
        YelpAPI.getSearchData(with: "coffee", locationCoordinate: )) { item in
            resultsSearchController.data.append(ResultsObject(title: "YelpBusinesses", items: item.businesses))
        }
        */
    }
    @IBAction func menuTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.menuConstraint.constant = self.menuConstraint.constant != 0 ? 0 : -self.tableView.frame.width*2
            self.view.layoutIfNeeded()
        })
    }
    func initializeSearchController(withData: [ResultsObject]) -> ResultsViewController {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "results") as! ResultsViewController
        //Abstract
        locationSearchTable.data = withData
        locationSearchTable.delegate = self
        return locationSearchTable
    }
    //Maybe this can be set with a viewmodel as well
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
        searchBar.delegate = self
    }
    //Dummy function should be changed
    @IBAction func addItemToDatabase(_ sender: Any) {
        count+=1
//        self.ref.child("item\(count)").setValue("New text")
        
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
        if let location = locations.last {
            mapView.setRegion(MKCoordinateRegionMake(location.coordinate, MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
            YelpAPI.getSearchData(with: "", locationCoordinate: location.coordinate) { item in
                var annotations: [MKPointAnnotation] = []
                for item in item.businesses {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: item.coordinates.latitude, longitude: item.coordinates.longitude)
                    annotation.title = item.name
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)
            }
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

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Call the delegate to update search results
        print(searchText)
    }
}
