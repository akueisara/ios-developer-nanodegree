//
//  Student.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/4/25.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import Foundation

// MARK: - UdacityStudent

struct UdacityStudent {
    
    // MARK: Properties
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String
    let uniqueKey: String?
    let updatedAt: String
    
    // MARK: Initializers
    
    // construct a UdacityStudent from a dictionary
    init(dictionary: [String:AnyObject]) {
        createdAt = dictionary[UdacityClient.JSONResponseKeys.StudentCreatedTime] as! String
        firstName = dictionary[UdacityClient.JSONResponseKeys.StudentFirstName] as! String
        lastName = dictionary[UdacityClient.JSONResponseKeys.StudentLastName] as! String
        latitude = dictionary[UdacityClient.JSONResponseKeys.StudentLatitude] as? Double
        longitude = dictionary[UdacityClient.JSONResponseKeys.StudentLongitude] as? Double
        mapString = dictionary[UdacityClient.JSONResponseKeys.StudentMapString] as? String
        mediaURL = dictionary[UdacityClient.JSONResponseKeys.StudentMediaURL] as? String
        objectId = dictionary[UdacityClient.JSONResponseKeys.StudentObjectId] as! String
        uniqueKey = dictionary[UdacityClient.JSONResponseKeys.StudentUniqueKey] as? String
        updatedAt = dictionary[UdacityClient.JSONResponseKeys.StudentUpdatedTime] as! String
    }
    
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [UdacityStudent] {
        
        var students = [UdacityStudent]()
        
        // iterate through array of dictionaries, each Student is a dictionary
        for result in results {
            students.append(UdacityStudent(dictionary: result))
        }
        
        return students
    }
    
}
