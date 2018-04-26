//
//  UDACITYClient.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/4/24.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ParseApiHost = "parse.udacity.com"
        static let ParseApiPath = "/parse/classes"
        static let UdacityApiHost = "www.udacity.com"
        static let UdacityApiPath = "/api"
        static let SignUpURL = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: Methods
    struct ParseMethods {
        
        // MARK: Student Locations
        static let StundetLocation = "/StudentLocation"
    }
    
    struct UdacityMethods {
        
        // MARK: Session
        static let Session = "/session"
        static let User = "/users/{id}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        // MARK: StudentLocation
        static let Limit = "limit"
        static let Order = "order"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let MaxNumber = "100"
        static let SortedOrder = "-updatedAt"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Authentication
        static let Account = "account"
        static let UserId = "key"
        
        // MARK: Students
        static let StudentCreatedTime = "createdAt"
        static let StudentFirstName = "firstName"
        static let StudentLastName = "lastName"
        static let StudentLatitude = "latitude"
        static let StudentLongitude = "longitude"
        static let StudentMapString = "mapString"
        static let StudentMediaURL = "mediaURL"
        static let StudentObjectId = "objectId"
        static let StudentUniqueKey = "uniqueKey"
        static let StudentUpdatedTime = "updatedAt"
        static let StudentResults = "results"
    }
}
