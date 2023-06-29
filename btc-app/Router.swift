//
//  Router.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//
import Foundation
import Alamofire
enum Router: URLRequestConvertible {
    static var baseURLString = "https://api.coindesk.com/v1/bpi/currentprice.json"
    
    var result: (path: String, parameters: Parameters?) {
        return ("\(Router.baseURLString)", nil)
    }
                
    var method: HTTPMethod {
        return .get
    }
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var params = result.parameters
        // Localized before sign in endpoints
        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if method == .get {
            return try URLEncoding.default.encode(urlRequest, with: params)
        } else {
            return try JSONEncoding.default.encode(urlRequest, with: params)
        }
    }
}
