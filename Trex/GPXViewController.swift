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
//                        self.clearWaypoints()
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
        clearWaypoints()
        mapView.addAnnotations(waypoints)
        mapView.showAnnotations(waypoints, animated: true)
    }
    
    private func handleTrack(tracks: [GPX.Track]) {
        for track in tracks {
            if track.fixes.count < 1 { continue } // skip empty tracks
            
            var coordinates: [CLLocationCoordinate2D] = track.fixes.map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }
            let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
            mapView.addOverlay(polyline, level: MKOverlayLevel.AboveRoads)
            
            // TODO: make it DRY
            let first = TrackFixWaypoint(latitude: coordinates.first!.latitude, longitude: coordinates.first!.longitude)
            first.name = "Start"
            first.info = track.name
            first.isFirstWaypoint = true
            let last = TrackFixWaypoint(latitude: coordinates.last!.latitude, longitude: coordinates.last!.longitude)
            last.name = "End"
            last.info = track.name
            
            mapView.showAnnotations([first, last], animated: true)
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
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(annotation is TrackFixWaypoint ? Constants.TrackpointAnnotationViewReuseIdentifier : Constants.WaypointAnnotationViewReuseIdentifier)
        
        if view == nil {
            if annotation is TrackFixWaypoint {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.TrackpointAnnotationViewReuseIdentifier)
                view.canShowCallout = true
            } else {
                view = InfoAnnotationView(annotation: annotation, reuseIdentifier: Constants.WaypointAnnotationViewReuseIdentifier)
                view.canShowCallout = false
            }
        } else {
            view.annotation = annotation
        }
        
        // if we're using the MKPinAnnotationView, set the pin color accordingly
        if let pinAnnotation = view as? MKPinAnnotationView {
            if let trackWaypoint = annotation as? TrackFixWaypoint {
                pinAnnotation.pinColor = trackWaypoint.isFirstWaypoint ? MKPinAnnotationColor.Green : MKPinAnnotationColor.Red
            } else {
                pinAnnotation.pinColor = MKPinAnnotationColor.Purple
            }
        }
        
        if let infoAnnotation = view as? InfoAnnotationView {
            infoAnnotation.caption = annotation.title
        }

        return view
    }

    // MARK: - Constants
    
    private struct Constants {
        static let WaypointAnnotationViewReuseIdentifier = "waypoint"
        static let TrackpointAnnotationViewReuseIdentifier = "trackpoint"
    }
    
}
