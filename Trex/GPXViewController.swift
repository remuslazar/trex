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
                        self.clearWaypoints()
                        self.handleWaypoints(gpx.waypoints)
                        self.handleTrack(gpx.tracks)
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
    
    private func handleTrack(tracks: [GPX.Track]) {
        for track in tracks {
            var coordinates: [CLLocationCoordinate2D] = track.fixes.map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }
            let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
            mapView.addOverlay(polyline, level: MKOverlayLevel.AboveRoads)
            mapView.showAnnotations([track.fixes.first!, track.fixes.last!], animated: true)
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.cyanColor()
            renderer.lineWidth = 3
            return renderer
        }
        return nil
    }
    
}
