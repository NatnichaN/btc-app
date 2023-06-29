//
//  Currency.swift
//  btc-app
//
//  Created by Natnicha on 29/6/23.
//

import Foundation
struct Currency {
    let contentTimeStamp: TimeStamp?
    let disclaimer: String
    let chartName: String
    let bpi: [BPI]
    enum CodingKeys: String, CodingKey {
        case contentTimeStamp = "time"
        case disclaimer
        case chartName
        case bpi
    }
}

struct TimeStamp {
    let updated: Date?
    let updatedISO: Date?
    let updatedUK: Date?
    
    enum CodingKeys: String, CodingKey {
        case updated
        case updatedISO
        case updatedUK = "updateduk"
    }
}

struct BPI {
    let usd: [BPIRate]?
    let gbp: [BPIRate]?
    let eur: [BPIRate]?
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
        case eur = "EUR"
    }
}

struct BPIRate {
    let code: String
    let symbol: String
    let rate: String
    let description: String
    let rateFloat: CGFloat
    
    enum CodingKeys: String, CodingKey {
        case code
        case symbol
        case rate
        case description
        case rateFloat = "rate_float"
    }
}
