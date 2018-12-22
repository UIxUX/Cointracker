//
//  PriceData.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/22/18.
//  Copyright © 2018 Org. All rights reserved.
//

import Foundation

struct AllHistoricPriceData: Codable {
    /// Contains PriceData of all Projects with all Timeframes
    var projectPriceDict: Dictionary<Project,AggregatedHistoricPriceData>
    
    init() {
        projectPriceDict = Dictionary<Project,AggregatedHistoricPriceData>()
    }
}

struct AggregatedHistoricPriceData: Codable {
    var dailyHistoryArray: [DailyHistory]
    var monthlyHistoryArray: [MonthlyHistory]
    var alltimeHistoryArray: [AlltimeHistory]
}

struct DailyHistory: Codable {
    var time: String
    var average: Double
}

struct MonthlyHistory: Codable {
    var average: Double
    var open: Double
    var low: Double
    var high: Double
    var time: String
}

struct AlltimeHistory: Codable {
    var volume: Double
    var low: Double?
    var time: String
    var high: Double?
    var average: Double
    var open: Double?
}
