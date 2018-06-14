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
class HomeViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var searchController: UISearchController? = nil
    let locationManager: CLLocationManager = CLLocationManager()
    var count = 0
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        ref = Database.database().reference(withPath: "test-items")
        
        ref.observe(.value, with: {snapshot in
            DispatchQueue.main.async {
                var someArray: [Any] = []
                for child in snapshot.children {
                    someArray.append(child)
                }
                self.setupSearchController(with: self.initializeSearchController(withData: someArray))
                self.setupSearchBar()
            }
        })
    }
    
    func initializeSearchController(withData: [Any]) -> ResultsViewController {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "results") as! ResultsViewController
        locationSearchTable.data = withData
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
    @IBAction func addItemToDatabase(_ sender: Any) {
        count+=1
        self.ref.child("item\(count)").setValue("New text")
    }
}

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
