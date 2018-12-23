//
//  DataProviders.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

enum DataProvider {
    case BitcoinAverage
    /// add more DataProviders in the future, e.g. CoinMarketCap Api
}

struct BitcoinAverage {
    static let host = "https://apiv2.bitcoinaverage.com"
    static let historyPath = "/indices/global/history/"
    static let currentPricePath = "/indices/global/ticker/"
    
    static func buildHistoryEndpointString(for project: Project, period: Period? = .Alltime, fiat: Fiat? = Fiat.USD) -> String {
        return "\(BitcoinAverage.host)\(BitcoinAverage.historyPath)\(project.rawValue)\(fiat!.rawValue)?period=\(period!.rawValue)&?format=json"
    }
    
    static func buildCurrentPriceEndpointString(for project: Project, fiat: Fiat? = Fiat.USD) -> String {
        return "\(BitcoinAverage.host)\(BitcoinAverage.currentPricePath)\(project.rawValue)\(fiat!.rawValue)"
    }
}
