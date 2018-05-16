//
//  UdacityClient.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/4/24.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UdacityClient: NSObject

class UdacityClient : NSObject {
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var userID: String? = nil
    
    // data for posting a new student location
    var userFirstName: String = ""
    var userLastName: String = ""
    var userObjectId: String = ""
    var userUniqueKey: String = ""
    
    // decide if showing overwrite
    var showOverwrite: Bool = false
    
    // decide if reload the views
    var loadViews = false
    var loadTableView = false
    var loadMapView = false
    
    var studentInformations: [StudentInformation]?
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Authentication (POST) Methods
    func getUserId(username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: NSError?, _ errormsg: String?) -> Void) {
        
         /* Build the URL, Configure the request */
        let parameters = [String:AnyObject]()
        var method: String = UdacityMethods.Session
        let request = NSMutableURLRequest(url: udacityURLFromParameters(UdacityClient.Constants.UdacityApiHost, UdacityClient.Constants.UdacityApiPath, parameters, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"\(UdacityClient.JSONBodyKeys.Username)\": \"\(username)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, _ errormsg: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForAuth(false, NSError(domain: "getUserId", code: 1, userInfo: userInfo), errormsg)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)", ErrorMessage.NoNetwork)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", ErrorMessage.InvalidEmailOrPassword)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", ErrorMessage.NoNetwork)
                return
            }
            
            /* Parse the data and use the data*/
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
                completionHandlerForAuth(false, NSError(domain: "getUserId", code: 1, userInfo: userInfo), ErrorMessage.NoNetwork)
            }
            
            guard let account = parsedResult?[UdacityClient.JSONResponseKeys.Account] as? [String:Any] else {
                sendError("Could not find \(UdacityClient.JSONResponseKeys.Account) in \(parsedResult!)", ErrorMessage.NoNetwork)
                return
            }
            
            guard let userID = account[UdacityClient.JSONResponseKeys.UserId] as? String else {
                sendError("Could not find \(UdacityClient.JSONResponseKeys.UserId) in \(account)", ErrorMessage.NoNetwork)
                return
            }
            
            self.userID = userID
 
            completionHandlerForAuth(true, nil, nil)
        }
        
        /* Start the request */
        task.resume()
    }
    
    func getUserData(userID: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        var method: String = UdacityMethods.User
        method = substituteKeyInMethod(method, key: UdacityClient.URLKeys.UserID, value: String(UdacityClient.sharedInstance().userID!))!
        let request = NSMutableURLRequest(url: udacityURLFromParameters(UdacityClient.Constants.UdacityApiHost, UdacityClient.Constants.UdacityApiPath, parameters, withPathExtension: method))
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForAuth(false, NSError(domain: "getUserData", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
           
            do {
                var _ = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
                completionHandlerForAuth(false, NSError(domain: "getUserData", code: 1, userInfo: userInfo))
            }
            
            completionHandlerForAuth(true, nil)
        }
        task.resume()
    }
    
    func logout() {
        
        let parameters = [String:AnyObject]()
        var method: String = UdacityMethods.Session
        let request = NSMutableURLRequest(url: udacityURLFromParameters(UdacityClient.Constants.UdacityApiHost, UdacityClient.Constants.UdacityApiPath, parameters, withPathExtension: method))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let _ = data else {
                sendError("No data was returned by the request!")
                return
            }
        }
        
        task.resume()
    }
    
    func getStudentLocations(completionHandlerForStudentData: @escaping (_ result: [StudentInformation]?, _ error: NSError?) -> Void) {
        
        let parameters = [UdacityClient.ParameterKeys.Limit: UdacityClient.ParameterValues.MaxNumber, UdacityClient.ParameterKeys.Order: UdacityClient.ParameterValues.SortedOrder] as [String : AnyObject]
        let method: String = ParseMethods.StundetLocation
        let request = NSMutableURLRequest(url: udacityURLFromParameters(UdacityClient.Constants.ParseApiHost, UdacityClient.Constants.ParseApiPath, parameters, withPathExtension: method))
        request.addValue(UdacityClient.Constants.ApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForStudentData(nil, NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandlerForStudentData(nil, NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo))
            }
            
            if let results = parsedResult?[UdacityClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]] {
                let students = StudentInformation.studentsFromResults(results)
                self.studentInformations = students
                completionHandlerForStudentData(students, nil)
            } else {
                completionHandlerForStudentData(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
            }
        }
        
        task.resume()
    }
    
    func getUserPostedInfo(uniqueKey: String) {
        self.showOverwrite = false
        let parameters = [UdacityClient.ParameterKeys.Where: substituteKeyInMethod(UdacityClient.ParameterValues.UniqueKey, key: UdacityClient.ParameterKeys.UniqueKey, value: uniqueKey)] as [String : AnyObject]
        let method: String = ParseMethods.StundetLocation
        let request = NSMutableURLRequest(url: udacityURLFromParameters(UdacityClient.Constants.ParseApiHost, UdacityClient.Constants.ParseApiPath, parameters, withPathExtension: method))
        request.addValue(UdacityClient.Constants.ApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            if let results = parsedResult as? [String: Any] {
                if let resultStudentSet = results["results"] as? [[String: AnyObject]], resultStudentSet.count != 0{
                    self.showOverwrite = true
                    let user = StudentInformation.studentsFromResults(resultStudentSet)[0]
                    self.userFirstName = user.firstName!
                    self.userLastName = user.lastName!
                    self.userObjectId = user.objectId
                    self.userUniqueKey = user.uniqueKey!
                }
            }
        }
        
        task.resume()
       
    }
    
    func addUserData(_ student: StudentInformation, _ location: String, _ method: String, _ httpMethod: String, _ completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        /* Build the URL, Configure the request */
        let parameters = [String:AnyObject]()
        let method: String = method
        let request = NSMutableURLRequest(url: udacityURLFromParameters(UdacityClient.Constants.ParseApiHost, UdacityClient.Constants.ParseApiPath, parameters, withPathExtension: method))
        request.httpMethod = httpMethod
        request.addValue(UdacityClient.Constants.ApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"\(UdacityClient.JSONResponseKeys.StudentUniqueKey)\": \"\(student.uniqueKey!)\", \"\(UdacityClient.JSONResponseKeys.StudentFirstName)\": \"\(student.firstName!)\", \"\(UdacityClient.JSONResponseKeys.StudentLastName)\": \"\(student.lastName!)\",\"\(UdacityClient.JSONResponseKeys.StudentMapString)\": \"\(location)\", \"\(UdacityClient.JSONResponseKeys.StudentMediaURL)\": \"\(student.mediaURL!)\",\"\(UdacityClient.JSONResponseKeys.StudentLatitude)\": \(student.latitude!), \"\(UdacityClient.JSONResponseKeys.StudentLongitude)\": \(student.longitude!)}".data(using: String.Encoding.utf8)
        
        /* Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(false, NSError(domain: "updateUserData", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard data != nil else {
                sendError("No data was returned by the request!")
                return
            }
            
            completionHandler(true, nil)
        }
        
        /* Start the request */
        task.resume()
    }
    
    func updateUserData(student: StudentInformation, location: String, completionHandlerForPut: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        addUserData(student, location, ParseMethods.StundetLocation + "/" + student.objectId, "PUT", completionHandlerForPut)
    }
    
    func postUserData(student: StudentInformation, location: String, completionHandlerForPost: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        addUserData(student, location, ParseMethods.StundetLocation, "POST", completionHandlerForPost)
    }
    

    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // create a URL from parameters
    private func udacityURLFromParameters(_ apiHost: String, _ apiPath: String ,_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = apiHost
        components.path = apiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%")

        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
