//
//  ResturauntListViewController.swift
//  AllTrailsMapSearchDemoStoryboard
//
//  Created by Daniel Spady on 11/13/25.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps
import MapKit

class ResturauntListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var toggleViewButton: MapButton!
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var resturauntList: [ResturauntListViewCellModel] = []
    var mapList: [ResturauntMapListModel] = []
    var filteredItems: [ResturauntListViewCellModel] = []
    let refreshControl = UIRefreshControl()
    
    private let lightGrayColor = UIColor(red: 0xEF, green: 0xEF, blue: 0xEC)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default View State
        setupView()
        
        // Table View Data Source and Delegate and Color
        // Also setup Pull to refresh
        setupTableView()
        
        // MapView delegate and user location
        setupMapView()
        
        // Search Delegate and View
        setupSearchBar()
        
        // Ask For Location Prompt
        setupLocationManager()
        
        // Request for Local Places using Google API
        fetchData()
    }
    
    func setupView() {
        mapView.isHidden = true
        tableView.isHidden = false
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = lightGrayColor
        tableView.keyboardDismissMode = .onDrag
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setupSearchBar() {
        searchBar.searchTextField.backgroundColor = lightGrayColor
        searchBar.delegate = self
    }
    
    func fetchData() {
        activityView.isHidden = false
        Task {
            if let coordinate = locationManager?.location?.coordinate {
                await performNearbySearch(center: coordinate, radius: 500.0)
            }
        }
    }
    
    func openMap() {
        guard let coordinate = locationManager?.location?.coordinate else { return }
        
        // Test Data
        // Annotations aren't shown because coordinate information returned isn't valid
//        let london = MKPointAnnotation()
//        london.title = "London"
//        london.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
//        mapView.addAnnotation(london)
        
        var annotations: [MKPointAnnotation] = []
        
        annotations = mapList.map({ mapItem in
            MKPointAnnotation(coordinate: mapItem.mapCoordinates,
                              title: mapItem.mapItemName,
                              subtitle: mapItem.mapItemSubtitle)
        })
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
        
        let latitudinalMeters: CLLocationDistance = 10000
        let longitudinalMeters: CLLocationDistance = 10000
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
        
        mapView.setRegion(region, animated: true)
    }
    
    // Button Action
    @IBAction func toggleView(_ sender: Any) {
        mapView.isHidden.toggle()
        tableView.isHidden.toggle()
        
        if mapView.isHidden {
            toggleViewButton.showMapView()
            tableView.reloadData()
        } else {
            toggleViewButton.showListView()
            openMap()
        }
    }
    
    // Table View Refresh
    @objc func refresh(_ sender: AnyObject) {
        fetchData()
    }
    
    // Google Request for Nearby Search
    func performNearbySearch(center: CLLocationCoordinate2D, radius: Double) async {
        let placesClient = GMSPlacesClient.shared()
        
        let locationRestriction = GMSPlaceCircularLocationOption(center, radius)
        
        let placeProperties: [String] = ["name", "coordinate", "placeID", "resturaunt", "types", "photos"]
        
        let nearbySearchRequest = GMSPlaceSearchNearbyRequest(locationRestriction: locationRestriction, placeProperties: placeProperties)
        
        do {
            let response = try await placesClient.searchNearby(with: nearbySearchRequest)
            
            if let places = response.places {
                
                // Map places to Map Annotations
                // Not getting correct lat and lan here
                mapList = places.map({ place in
                    dump(place.coordinate)

                    return ResturauntMapListModel(mapCoordinates: place.coordinate,
                                           mapItemName: place.name ?? "No Name",
                                           mapItemSubtitle: place.editorialSummary ?? "No Summary")
                })
                
                // Map Places to Table View List
                resturauntList = places.map({ place in
                    ResturauntListViewCellModel(cellIconPlaceholder: .placeholder,
                                                cellHeader: place.name ?? "No name",
                                                cellRatingIcon: .star,
                                                cellRating: place.rating,
                                                cellReviews: place.reviews?.first?.text ?? "No reviews",
                                                cellSupporting: place.editorialSummary ?? "No Summary",
                                                cellBookmarkName: .bookmarkSaved)
                })
                
                // Filtered Items for Searching
                filteredItems = resturauntList
                
                // Update UI on Main Actor
                // Dismiss Activity View
                // End Refreshing for pull to refresh
                await MainActor.run {
                    tableView.reloadData()
                    activityView.isHidden = true
                    refreshControl.endRefreshing()
                }
            }
        } catch {
            print("An unexpected error occurred: \(error.localizedDescription)")
        }
    }
}
