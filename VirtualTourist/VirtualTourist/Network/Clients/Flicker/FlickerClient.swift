//
//  FlickerClient.swift
//  VirtualTourist
//
//  Created by Kuei-Jung Hu on 2020/4/22.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

import MapKit

// MARK: - FlickerClient: NSObject

class FlickerClient : NSObject {

    // MARK: Properties
    
    // shared session
    lazy var session: SessionProtocol = URLSession.shared
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
     
     func taskForGETMethod(parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
         
         /* 1. Set the parameters */
         var parametersWithApiKey = parameters
         parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
        parametersWithApiKey[ParameterKeys.Format] = ParameterValues.Json as AnyObject?
        parametersWithApiKey[ParameterKeys.NoJsonCallback] = ParameterValues.JsonCallbackValue as AnyObject?
         
         /* 2. Build the URL */
         let url = flickerURLFromParameters(parametersWithApiKey)
         
         /* 3. Make the request */
         let task = session.dataTask(with: url) { (data, response, error) in
             
             func sendError(_ error: String) {
                 print(error)
                 let userInfo = [NSLocalizedDescriptionKey : error]
                 completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
             }
             
             /* GUARD: Was there an error? */
             guard error == nil else {
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
             
             /* 4/5. Parse the data and use the data (happens in completion handler) */
             self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
         }
         
         /* 6. Start the request */
         task.resume()
         
         return task
     }
    
     func taskForGETImage(_ imageURL: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        /* 1. Set the parameters */
        // There are none...
        
        /* 2. Build the URL */
        let baseURL = URL(string: imageURL)!
        
        /* 3. Make the request */
        let task = session.dataTask(with: baseURL) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForImage(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                sendError("Your request returned a status code other than 2xx!")
//                return
//            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 4/5. Parse the data and use the data (happens in completion handler) */
            completionHandlerForImage(data, nil)
        }
        
        /* 6. Start the request */
        task.resume()
        
        return task
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
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    private func flickerURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = FlickerClient.Constants.ApiScheme
        components.host = FlickerClient.Constants.ApiHost
        components.path = FlickerClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters.sorted( by: { $0.0 < $1.0 }) {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
    
protocol SessionProtocol {
  func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask
}

extension URLSession: SessionProtocol {}
