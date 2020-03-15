//
//  AppNetworking.swift
//  SearchWithWikipedia
//
//  Created by Vipul Kumar on 15/03/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]
typealias FailureResponse = (Error) -> (Void)

//enum AppNetworking {
//
//    //MARK: Functions
//    //===============================
//    static func get(endPoint : String,
//                    parameters : JSONDictionary = [:],
//                    headers : HTTPHeaders = [:],
//                    loader : Bool = true,
//                    success : @escaping (Data) -> Void,
//                    failure : @escaping (Error) -> Void) {
//
//        request(URLString: endPoint, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, success: success, failure: failure)
//    }
//
//    private static func request(URLString : String,
//                                httpMethod : HTTPMethod,
//                                parameters : JSONDictionary = [:],
//                                encoding: ParameterEncoding = URLEncoding.default,
//                                headers : HTTPHeaders = [:],
//                                success : @escaping (Data) -> Void,
//                                failure : @escaping (Error) -> Void) {
//
//        Alamofire.request(URLString, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers)
//
//            .responseData { (response) in
//
//                print(response)
//
//                switch response.result {
//
//                case .success(let data):
//
//                    print(response.debugDescription)
//
//                    success(data)
//
//                case .failure(let e):
//                    failure(e)
//                }
//        }
//    }
//}

enum AppNetworking {

    //MARK: Functions
    //===============================
    static func get(endPoint : String,
                    parameters : JSONDictionary = [:],
                    headers : HTTPHeaders = [:],
                    httpMethod: HTTPMethod = .get,
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {

        request(URLString: endPoint, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, success: success, failure: failure)
    }

    private static func request(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                encoding: ParameterEncoding = URLEncoding.default,
                                headers : HTTPHeaders = [:],
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void) {

//        print("\n*********************")
//        print(parameters)
//        print("*********************\n")

        Alamofire.request(URLString, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers)
            .responseJSON { response in

                print(response)
                
                switch(response.result) {
                case .success(let value):
                    success(JSON(value))
                case .failure(let e):
                    failure(e)
                }
        }
    }
}
