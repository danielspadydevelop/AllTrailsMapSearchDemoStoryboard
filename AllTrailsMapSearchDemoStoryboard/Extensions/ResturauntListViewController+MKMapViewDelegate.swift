//
//  ResturauntListViewController+MKMapViewDelegate.swift.swift
//  AllTrailsMapSearchDemoStoryboard
//
//  Created by Daniel Spady on 11/19/25.
//

import MapKit

extension ResturauntListViewController: MKMapViewDelegate {
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
//        let identifier = "ResturauntItem"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//        if annotationView == nil {
//            print("no reusable view")
//            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView!.canShowCallout = true
//
//            let btn = UIButton(type: .detailDisclosure)
//            btn.setImage(.pinResting, for: .normal)
//            btn.setImage(.pinSelected, for: .selected)
//            annotationView!.rightCalloutAccessoryView = btn
//        } else {
//            print("reusing a view")
//            annotationView!.annotation = annotation
//        }
//
//        return annotationView
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                mapView.setRegion(viewRegion, animated: false)
                openMap()
            }
        }
    }
}
