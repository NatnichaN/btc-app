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
    
    enum CodingKeys: String, CodingKey {
        case code
        case symbol
        case rate
        case description
        case rateFloat = "rate_float"
    }
}

extension BPIRate: Decodable {}
