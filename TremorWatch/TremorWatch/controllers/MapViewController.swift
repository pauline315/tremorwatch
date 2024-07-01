//
//  MapViewController.swift
//  TremorWatch
//
//  Created by EMTECH MAC on 26/06/2024.
//

import UIKit
import MapKit
import CoreLocationUI


class MapViewController: UIViewController {
    
        let map = MKMapView()
        let locationManager = CLLocationManager()
    
    var currentMap: MKMapType = .satellite {
        
        didSet{
            map.mapType = currentMap
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubViews(map)
        map.fillSuperview()
        setupRegion()
        addSegmentControl()
        locationButton()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setupRegion() {
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: 40.8518, longitude: 14.2681)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    
    }
    func addSegmentControl() {
        
        let segments = ["Standard", "Satelite"]
        let control = UISegmentedControl(items: segments)
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .systemPurple
        control.addTarget(self, action: #selector(handleMapChange(_ :))
                          , for: .valueChanged)
        
        view.addSubview(control)
        control.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        control.centerX(inView: view)
    }
    
    @objc func handleMapChange(_ segmentedControl: UISegmentedControl){
        
        switch(segmentedControl.selectedSegmentIndex){
        case 0:
            currentMap = .standard
        case 1:
            currentMap = .satellite
            
        default:
            break
        }
    }
    
    func locationButton(){
        
        let locationButton = CLLocationButton()
        
        locationButton.setSize(height: 50, width: 50)
        locationButton.cornerRadius = 25
        
        locationButton.icon = .arrowFilled
        
        view.addSubview(locationButton)
        locationButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing:
            view.trailingAnchor,paddingBottom: 8,paddingTrailing: 8)
        locationButton.backgroundColor = .white
        locationButton.tintColor = .systemPurple
        locationButton.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
    }
    
    @objc func getCurrentLocation(){
        self .locationManager.startUpdatingLocation()
    }
}
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:
                         [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        map.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
        locationManager.stopUpdatingLocation()
    }
}
