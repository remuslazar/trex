//
//  GPXViewController.swift
//  Trex
//
//  Created by Remus Lazar on 25.05.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import MapKit

class GPXViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Satellite
            mapView.delegate = self
        }
    }

    // MARK: - Public API
    
    var gpxURL: NSURL? {
        didSet {
            if let url = gpxURL {
                GPX.parse(url) {
                    if let gpx = $0 {
                        self.handleWaypoints(gpx.waypoints)
                    }
                }
            }
        }
    }
    
    // MARK: - Internal
    
    private func clearWaypoints() {
        if mapView?.annotations != nil { mapView.removeAnnotations(mapView.annotations as! [MKAnnotation]) }
    }
    
    private func handleWaypoints(waypoints: [GPX.Waypoint]) {
        mapView.addAnnotations(waypoints)
        mapView.showAnnotations(waypoints, animated: true)
    }
    
}
