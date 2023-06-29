//
//  ResponseSerializerDecodeble.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import Foundation
import Alamofire

private let emptyDataStatusCodes: Set<Int> = [204, 205]

extension DataRequest {
    @discardableResult
    func responseDecodable<T: Decodable>(queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated), of t: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) -> Self {
            return response(queue: .main, responseSerializer: ResponseSerializerDecodeble<T>()) { response in
                switch response.result {
                case .success(let result):
                    completionHandler(result)
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
}

final class ResponseSerializerDecodeble<T: Decodable>: ResponseSerializer {
    lazy var decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
    }()
    private lazy var successSerializer = DecodableResponseSerializer<T>(decoder: decoder)
    private lazy var errorSerializer = DecodableResponseSerializer<APIError>(decoder: decoder)

    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> Result<T, Error>  {
        guard error == nil else { return .failure(error!) }

        if let response = response, emptyDataStatusCodes.contains(response.statusCode) {
            do {
                let emptyContent = "{}"
                let data = emptyContent.data(using: .utf8)!
                let result = try successSerializer.serialize(request: request, response: response, data: data, error: nil)
                return .success(result)
            } catch {
                return .failure(error)
            }
        }
        guard let data = data else { return .failure(error!) }
        do {
            if (200..<300).contains(response!.statusCode){
                let result = try successSerializer.serialize(request: request, response: response, data: data, error: nil)
                return .success(result)
            } else {
                _ = try errorSerializer.serialize(request: request, response: response, data: data, error: nil)
                return .failure(error!)
            }
        } catch {
            return .failure(error)
        }
    }
}
