//
//  Constants.swift
//  Coinsignals
//
//  Created by Julian Praest on 21.12.18.
//  Copyright © 2018 Org. All rights reserved.
//

import Foundation


struct Constants {
    struct API {
        enum BitcoinAverage {
            static let host = "https://apiv2.bitcoinaverage.com"
            static let historyPath = "/indices/global/history/"
            //"BTCUSD?period=daily&?format=json"
            
            //
            func buildHistoryEndpointString(for project: Project, period: Period? = .Alltime) -> String {
                return "\(Constants.API.BitcoinAverage.host)\(historyPath)"
            }
        }
    }
}
