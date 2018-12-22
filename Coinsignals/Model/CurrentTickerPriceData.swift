//
//  CurrentTickerPriceData.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/22/18.
//  Copyright © 2018 Org. All rights reserved.
//

import Foundation

struct AllCurrentTickerPriceData: Codable {
    /// Contains PriceData of all Projects of current Time
    var projectPriceDict: Dictionary<Project,CurrentTickerPriceData>
    
    init() {
        projectPriceDict = Dictionary<Project,CurrentTickerPriceData>()
    }
}

struct CurrentTickerPriceData: Codable {
    var ask: Double
    var bid: Double
    var last: Double
    var high: Double
    var low: Double
    var open: Open
    var averages: Averages
    var volume: Double
    var changes: Changes
    var volume_percent: Double
    let timestamp : Int
    let display_timestamp : String
}

struct Open: Codable {
    var hour: Double
    var day: Double
    var week: Double
    var month: Double
    var month_3: Double
    var month_6: Double
    var year: Double
}

struct Averages: Codable {
    var day: Double
    var week: Double
    var month: Double
}

struct Changes: Codable {
    var percent: Open
    var price: Open
}
