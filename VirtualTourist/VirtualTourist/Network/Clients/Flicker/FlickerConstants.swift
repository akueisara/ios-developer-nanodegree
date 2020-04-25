//
//  FlickerConstant.swift
//  VirtualTourist
//
//  Created by Kuei-Jung Hu on 2020/4/22.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

// MARK: - FlickerClient (Constants)

extension FlickerClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "939a61dfe9cbfa52dc804e0c24ec95c2"
                        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.flickr.com"
        static let ApiPath = "/services/rest"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let Format = "format"
        static let NoJsonCallback = "nojsoncallback"
        static let Method = "method"
        static let Latitude = "lat"
        static let Longitude = "lon"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let Json = "json"
        static let JsonCallbackValue = 1
    }
}
