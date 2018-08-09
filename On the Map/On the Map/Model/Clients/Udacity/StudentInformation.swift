//
//  Student.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/4/25.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import Foundation

// MARK: - StudentInformation

struct StudentInformation: Codable {
    
    // MARK: Properties
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
