//
//  FlickerConvenience.swift
//  VirtualTourist
//
//  Created by Kuei-Jung Hu on 2020/4/22.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

import MapKit

// MARK: - FlickerClient (Convenient Resource Methods)

extension FlickerClient {
    
    func getPhotos(coord: CLLocationCoordinate2D, page: Int, completionHandlerForPhotos: @escaping (_ result: [FlickerImage]?, _ pages: Int?, _ error: NSError?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [FlickerClient.ParameterKeys.Method : FlickerClient.ParameterValues.SearchMethod,
                          FlickerClient.ParameterKeys.Latitude: String(coord.latitude),
                          FlickerClient.ParameterKeys.Longitude: String(coord.longitude)]
        let method: String = FlickerClient.Methods.Rest
        
        /* 2. Make the request */
        let _ = taskForGETMethod(method, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPhotos(nil, nil, error)
            } else {
                if let photosResults = results?["photos"] as? [String:AnyObject], let pages = photosResults["pages"] as? Int, let imageResults = photosResults["photo"] as? [[String:AnyObject]] {
                    let photos = FlickerImage.flickerImagesFromResults(imageResults)
                    completionHandlerForPhotos(photos, pages, nil)
                } else {
                    completionHandlerForPhotos(nil, nil, NSError(domain: "getPhotos parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPhotos"]))
                }
            }
        }
    }
    
    func getPhotoImageData(photo: Photo, completionHandlerForPhotoImageData: @escaping (_ result: Data?, _ error: NSError?) -> Void) {
        if let photoImageUrl = photo.imageUrl {
            let _ = taskForGETImage(photoImageUrl) { (data, error) in
                
                /* Send the desired value(s) to completion handler */
                if let error = error {
                    completionHandlerForPhotoImageData(nil, error)
                } else {
                    completionHandlerForPhotoImageData(data, nil)
                }
            }
        }
    }
}
