//
//  MkMapView+Extensions.swift
//  VirtualTourist
//
//  Created by Kuei-Jung Hu on 2020/4/22.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

import MapKit

extension MKMapView {
    
    func addAnnotationToMap(coordinate: CLLocationCoordinate2D) {
        let pinAnnotation: MKPointAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = coordinate
        addAnnotation(pinAnnotation)
    }
}
