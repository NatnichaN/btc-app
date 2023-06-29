//
//  APIError.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import Foundation
struct APIError {
    var message: String?

    enum CodingKeys: String, CodingKey {
        case message
    }
}

extension APIError: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try values.decode(String.self, forKey: .message)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
    }
}
