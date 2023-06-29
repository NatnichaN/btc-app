//
//  Currency.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import Foundation

struct Currency {
    var contentTimeStamp: TimeStamp
    var disclaimer: String
    var chartName: String
    var bpi: BPI
    
    enum CodingKeys: String, CodingKey {
        case contentTimeStamp = "time"
        case disclaimer
        case chartName = "chartName"
        case bpi
    }
}

extension Currency: Decodable {}

struct TimeStamp {
    var updated: String
    var updatedISO: String
    var updatedUK: String
    
    enum CodingKeys: String, CodingKey {
        case updated
        case updatedISO
        case updatedUK = "updateduk"
    }
}

extension TimeStamp: Decodable {}

struct BPI {
    var usd: BPIRate
    var gbp: BPIRate
    var eur: BPIRate
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
        case eur = "EUR"
    }
}

extension BPI: Decodable {}

struct BPIRate {
    var code: String
    var symbol: String
    var rate: String
    var description: String
    var rateFloat: CGFloat
    // custom param
    var type: BPIType
    
    enum CodingKeys: String, CodingKey {
        case code
        case symbol
        case rate
        case description
        case rateFloat = "rate_float"
        case type
    }
}

extension BPIRate: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try values.decode(String.self, forKey: .code)
        self.symbol = try values.decode(String.self, forKey: .symbol)
        self.rate = try values.decode(String.self, forKey: .rate)
        self.description = try values.decode(String.self, forKey: .description)
        self.rateFloat = try values.decode(CGFloat.self, forKey: .rateFloat)
        self.type = try values.decode(BPIType.self, forKey: .code)
    }
}
