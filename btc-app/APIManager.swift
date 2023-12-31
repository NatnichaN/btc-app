//
//  APIManager.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import Foundation
import Alamofire
class APIManger {
    static let shared = APIManger()
    var sessionManager: Session = Session.default
    var configuration: URLSessionConfiguration = URLSessionConfiguration.default {
        didSet {
            configuration.requestCachePolicy = .useProtocolCachePolicy
        }
    }

    init() {
        sessionManager = Session(configuration: configuration, interceptor: nil)
    }
    
    func coinDesk(success: ((_ currency: Currency) -> Void)?, failure: ((_ error: Error) -> Void)?) {
        _ = sessionManager.request(Router.baseURLString)
            .responseDecodable(of: Currency.self, completionHandler:  { response in
                switch response {
                case .success(let response):
                    success?(response)
                case .failure(let error):
                    failure?(error)
                }
            })
    }
}
