//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Kuei-Jung Hu on 2020/4/21.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

import UIKit
import MapKit

// MARK: - TravelLocationsMapViewController

class TravelLocationsMapViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    var pins:[Pin] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let longPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        longPressGestureRecognizer.addTarget(self, action:#selector(recognizeLongPress(_:)))
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    
        setupPins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupPins()
    }
    
    @objc private func recognizeLongPress(_ sender: UILongPressGestureRecognizer) {
        // Do not generate pins many times during long press.
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
        mapView.addAnnotationToMap(coordinate: coordinate)
        CoreDataController.shared.addPin(coordinate: coordinate) { pin in
            pins.append(pin)
        }
    }
    
    func setupPins() {
        pins = CoreDataController.shared.loadPins()
        for pin in pins {
            let coord = CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.lon)
            mapView.addAnnotationToMap(coordinate: coord)
        }
    }
}

// MARK: - MKMapViewDelegate

extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coordinate = view.annotation?.coordinate
        for pin in pins {
            if pin.lat == coordinate?.latitude && pin.lon == coordinate?.longitude {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
                controller.selectedPin = pin
                navigationController?.pushViewController(controller, animated: true)
                break
            }
        }
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}
