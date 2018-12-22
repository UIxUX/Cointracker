//
//  DataAPI.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/22/18.
//  Copyright © 2018 Org. All rights reserved.
//

import Foundation

final class DataAPI {
    static let shared = DataAPI()
    private let persistencyManager: PersistencyManager = {
        /// Setup PersistencyManager
        var allCurrentTickerPriceData = AllCurrentTickerPriceData()
        var allHistoricPriceData = AllHistoricPriceData()
        var allSentimentData = AllSentimentData()
        var allRsiData = AllRsiData()
        
        var pManager = PersistencyManager(allCurrentTickerPriceData: allCurrentTickerPriceData, allHistoricPriceData: allHistoricPriceData, allSentimentData: allSentimentData, allRsiData: allRsiData)
        
        return pManager
    }()
    
    
    /// - Mark: Get / Set / Locally Save CURRENT Price Data
    
    func getAllLocalCurrentTickerPriceData() -> AllCurrentTickerPriceData {
        return persistencyManager.getAllCurrentTickerPriceData()
    }
    
    func getLocalCurrentTickerPriceData(project: Project) -> CurrentTickerPriceData? {
        return persistencyManager.getLocalCurrentTickerPriceData(project: project)
    }
    
    func updateLocalPriceData(project: Project, currentTickerPriceData: CurrentTickerPriceData) {
        persistencyManager.updateAllCurrentTickerPriceData(project: project, currentTickerPriceData: currentTickerPriceData)
    }
    
    func saveAllCurrentTickerPriceDataLocally() {
        persistencyManager.saveAllCurrentTickerPriceDataLocally()
    }
    
    
    /// - Mark: Get / Set / Locally Save HISTORIC Price Data

    func getAllHistoricPriceData() -> AllHistoricPriceData {
        return persistencyManager.getAllHistoricPriceData()
    }
    
    func getHistoricPriceData(project: Project) -> AggregatedHistoricPriceData? {
        return persistencyManager.getHistoricPriceData(project: project)
    }
    
    func updateLocalHistoricPriceData(project: Project, aggregatedHistoricPriceData: AggregatedHistoricPriceData) {
        return persistencyManager.updateLocalHistoricPriceData(project: project, aggregatedHistoricPriceData: aggregatedHistoricPriceData)
    }
    
    func saveAllHistoricPriceDataLocally() {
        persistencyManager.saveAllHistoricPriceDataLocally()
    }
    
    
    /// - Mark: Get / Set / Locally Save Sentiment Data
    
    func getAllSentimentData() -> AllSentimentData {
        return persistencyManager.getAllSentimentData()
    }
    
    func getSentimentData(project: Project) -> Sentiment? {
        return persistencyManager.getSentimentData(project: project)
    }
    
    func updateLocalSentimentData(project: Project, sentiment: Sentiment) {
        persistencyManager.updateLocalSentimentData(project: project, sentiment: sentiment)
    }
    
    func saveAllSentimentDataLocally() {
        persistencyManager.saveAllSentimentDataLocally()
    }
    
    
    /// - Mark: Get / Set / Locally Save RSI Data
    
    func getAllRsiData() -> AllRsiData {
        return persistencyManager.getAllRsiData()
    }
    
    func getRsiData(project: Project) -> Rsi? {
        return persistencyManager.getRsiData(project: project)
    }
    
    func updateLocalRsiData(project: Project, rsi: Rsi) {
       persistencyManager.updateLocalRsiData(project: project, rsi: rsi)
    }
    
    func saveAllRsiDataLocally() {
        persistencyManager.saveAllRsiDataLocally()
    }
    
    private init() {}
}


final class PersistencyManager {
    
    private var allCurrentTickerPriceData: AllCurrentTickerPriceData!
    private var allHistoricPriceData: AllHistoricPriceData!
    private var allSentimentData: AllSentimentData!
    private var allRsiData: AllRsiData!
    
    fileprivate init(allCurrentTickerPriceData: AllCurrentTickerPriceData, allHistoricPriceData: AllHistoricPriceData, allSentimentData: AllSentimentData, allRsiData: AllRsiData) {
        self.allCurrentTickerPriceData = allCurrentTickerPriceData
        self.allHistoricPriceData = allHistoricPriceData
        self.allSentimentData = allSentimentData
        self.allRsiData = allRsiData
    }
    
    /// - Mark: Get / Set / Locally Save CURRENT Price Data
    
    fileprivate func getAllCurrentTickerPriceData() -> AllCurrentTickerPriceData {
        return allCurrentTickerPriceData
    }
    
    fileprivate func getLocalCurrentTickerPriceData(project: Project) -> CurrentTickerPriceData? {
        return allCurrentTickerPriceData.projectPriceDict[project]
    }
    
    fileprivate func updateAllCurrentTickerPriceData(project: Project, currentTickerPriceData: CurrentTickerPriceData) {
        allCurrentTickerPriceData.projectPriceDict.updateValue(currentTickerPriceData, forKey: project)
    }
    
    fileprivate func saveAllCurrentTickerPriceDataLocally() {
        /// TODO
    }
    
    /// - Mark: Get / Set / Locally Save HISTORIC Price Data
    
    fileprivate func getAllHistoricPriceData() -> AllHistoricPriceData {
        return allHistoricPriceData
    }
    
    fileprivate func getHistoricPriceData(project: Project) -> AggregatedHistoricPriceData? {
        return allHistoricPriceData.projectPriceDict[project]
    }
    
    fileprivate func updateLocalHistoricPriceData(project: Project, aggregatedHistoricPriceData: AggregatedHistoricPriceData) {
        allHistoricPriceData.projectPriceDict.updateValue(aggregatedHistoricPriceData, forKey: project)
    }
    
    fileprivate func saveAllHistoricPriceDataLocally() {
        /// TODO
    }
    
    
    /// - Mark: Get / Set / Locally Save Sentiment Data
    
    fileprivate func getAllSentimentData() -> AllSentimentData {
        return allSentimentData
    }
    
    fileprivate func getSentimentData(project: Project) -> Sentiment? {
        return allSentimentData.projectSentimentDict[project]
    }
    
    fileprivate func updateLocalSentimentData(project: Project, sentiment: Sentiment) {
        allSentimentData.projectSentimentDict.updateValue(sentiment, forKey: project)
    }
    
    fileprivate func saveAllSentimentDataLocally() {
        /// TODO
    }
    
    
    /// - Mark: Get / Set / Locally Save RSI Data
    
    fileprivate func getAllRsiData() -> AllRsiData {
        return allRsiData
    }
    
    fileprivate func getRsiData(project: Project) -> Rsi? {
        return allRsiData.projectRsiDict[project]
    }
    
    fileprivate func updateLocalRsiData(project: Project, rsi: Rsi) {
        allRsiData.projectRsiDict.updateValue(rsi, forKey: project)
    }
    
    fileprivate func saveAllRsiDataLocally() {
        /// TODO
    }
    
}
