//
//  RegiftErrorEnum.swift
//  
//
//  Created by Gabrielle Miller-Messner on 4/14/16.
//
//

import Foundation

// Errors thrown by Regift
@objc public enum RegiftError: Int, ErrorType {
    case destinationNotFound = 997
    case addFrameToDestination = 998
    case destinationFinalize = 999
}
