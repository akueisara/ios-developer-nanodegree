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
    
    // MARK: Shared Instance
      
      class func sharedInstance() -> FlickerClient {
          struct Singleton {
              static var sharedInstance = FlickerClient()
          }
          return Singleton.sharedInstance
      }
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
     
     func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
         
         /* 1. Set the parameters */
         var parametersWithApiKey = parameters
         parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
         parametersWithApiKey["format"] = "json" as AnyObject?
         parametersWithApiKey["nojsoncallback"] = 1 as AnyObject?
         
         /* 2/3. Build the URL, Configure the request */
        print(flickerURLFromParameters(parametersWithApiKey, withPathExtension: method))
         let request = NSMutableURLRequest(url: flickerURLFromParameters(parametersWithApiKey, withPathExtension: method))
         
         /* 4. Make the request */
         let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
             
             func sendError(_ error: String) {
                 print(error)
                 let userInfo = [NSLocalizedDescriptionKey : error]
                 completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
             
             /* 5/6. Parse the data and use the data (happens in completion handler) */
             self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
         }
         
         /* 7. Start the request */
         task.resume()
         
         return task
     }
    
     func taskForGETImage(_ imageURL: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: NSError?) -> Void) -> URLSessionTask {
        
        /* 1. Set the parameters */
        // There are none...
        
        /* 2/3. Build the URL and configure the request */
        let baseURL = URL(string: imageURL)!
        let request = URLRequest(url: baseURL)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request) { (data, response, error) in
            
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
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForImage(data, nil)
        }
        
        /* 7. Start the request */
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
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
    
