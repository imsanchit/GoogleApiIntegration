//
//  ApiManager.swift
//  GoogleApiIntegration
//
//  Created by Sanchit Mittal on 12/10/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

final class ApiManager {
    static let sharedInstance = ApiManager()
    private init() {}
    
//    https://maps.googleapis.com/maps/api/geocode/json?address=lohia+nagar
    let baseUrl: String = "https://maps.googleapis.com/maps/api/geocode/json?"
    var parameters: [String: Any] = [:]
    let encoding: URLEncoding = URLEncoding.default
    let headers: HTTPHeaders = [:]
    
    
    public func getLocations(address: String, showResponse: @escaping(_ customLocation: CustomLocationResponse?) -> Void, showError: @escaping() -> Void) {
        let path = baseUrl
        let url = URL(string: path)
        parameters["address"] = address
        
//        let path = baseURL + "sources"
//        let url = URL(string: path)
//        let method: HTTPMethod = .get
        
        getResponse(url: url!,parameters: parameters, completion: { (_ responseType: CustomLocationResponse?, _ error: Error?) -> Void in
            if error != nil {
                showError()
                return
            }
            showResponse(responseType)
        })
    }
    
    private func getResponse<T: Mappable>(url: URL,parameters: [String: Any], completion:@escaping(_ responseType: T?, _ error: Error?) -> Void) {
        Alamofire.request(url,parameters: parameters).responseObject(completionHandler: {(response:DataResponse<T>) -> Void in
            completion(response.result.value, response.error)
        })
    }
}

//private func getResponse<T: Mappable>(url: URL,method: HTTPMethod, parameters: [String: Any], encoding: URLEncoding, headers: HTTPHeaders, completion:@escaping(_ responseType: T?, _ error: Error?) -> Void) {
//    Alamofire.request(url).response(completionHandler: {(response:DataResponse<T>) -> Void in
//        completion(response.result.value, response.error)
//
////    Alamofire.request(url,method: .get, parameters: parameters, encoding: encoding, headers: headers).responseObject(completionHandler:     })
//})
//    }
//}
