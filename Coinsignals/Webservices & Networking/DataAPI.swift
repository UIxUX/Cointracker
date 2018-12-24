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
        
        /// When initiating PersistencyManager, we look for locally saved objects that can be assessed
        
        pManager.retrieveSavedAllCurrentTickerPriceData(completion: {(savedAllCurrentTickerPriceData) -> Void in
            if savedAllCurrentTickerPriceData != nil {
                pManager.updateAllCurrentTickerPriceData(allCurrentTickerPriceData: savedAllCurrentTickerPriceData!)
            } else {
                print("savedAllCurrentTickerPriceData == nil")
            }
        })
        
        pManager.retrieveSavedAllHistoricPriceData(completion: {(savedAllHistoricPriceData) -> Void in
            if savedAllHistoricPriceData != nil {
                pManager.updateAllHistoricPriceData(allHistoricPriceData: savedAllHistoricPriceData!)
            } else {
                print("savedAllHistoricPriceData == nil")
            }
        })
        
        pManager.retrieveSavedAllRsiData(completion: {(savedAllRsiData) -> Void in
            if savedAllRsiData != nil {
                pManager.updateLocalAllRsiData(allRsiData: savedAllRsiData!)
            } else {
                /// Calculate and Save RsiData?
            }
        })
        
        
        return pManager
    }()
    
    private let currentPriceSubscriptionManager = CurrentPriceSubscriptionManager()
    private let sentimentManager = TwitterSentimentAnalyser()
    
    /// - Mark: Start subscribing to price data
    
    func startExternalCurrentTickerPriceDataSubscription(project: Project, completion: @escaping ((CurrentTickerPriceData) -> Void)) {
        
        let completionAndUpdateAndSave: (CurrentTickerPriceData) -> Void =  { (currentTickerPriceData) -> Void in
            completion(currentTickerPriceData)
            self.updateLocalPriceData(project: project, currentTickerPriceData: currentTickerPriceData)
            self.saveAllCurrentTickerPriceDataLocally()
        }
        
        currentPriceSubscriptionManager.startSubscribingToPriceData(project: project, completion: completionAndUpdateAndSave)
    }
    
    
    /// - Mark: Simply get current Price Data
    
    func getExternalCurrentTickerPriceData(project: Project, completion: @escaping ((CurrentTickerPriceData) -> Void)) {
        let webservice = Webservice()
        
        webservice.getCurrentPriceData(dataProvider: .BitcoinAverage, project: project, completion: { currentPriceData -> Void in
            completion(currentPriceData)
            /// Update and Save
            self.updateLocalPriceData(project: project, currentTickerPriceData: currentPriceData)
            self.saveAllCurrentTickerPriceDataLocally()
        } )
    }
    
    
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
    
    
    
    /// - Mark: Simply get Price History for Period
    
    func getExternalPriceHistoryData(project: Project, period: Period, completion: @escaping (([History]) -> Void)) {
        let webservice = Webservice()
        
        webservice.getHistoricPriceData(dataProvider: .BitcoinAverage, project: project, period: period, completion: {
            (historicData) -> Void in
            /// Update and Save
            self.updateLocalHistoricPriceData(project: project, priceHistory: historicData, period: period)
            
            /// Calculate Rsi and save
            let rsi = RSICalculator.calculateRSI(data: historicData)
            print("lll just calculated RSI: \(rsi)")
            self.updateLocalRsiData(project: project, rsi: rsi)
            
            completion(historicData)
            
            self.saveAllHistoricPriceDataLocally()
            self.saveAllRsiDataLocally()
        })
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
    
    func updateLocalHistoricPriceData(project: Project, priceHistory: [History], period: Period) {
        persistencyManager.updateLocalHistoricPriceData(project: project, history: priceHistory, period: period)
    }
    
    func saveAllHistoricPriceDataLocally() {
        persistencyManager.saveAllHistoricPriceDataLocally()
    }
    
    
    /// - Mark: Get / Set / Locally Save Sentiment Data
    
    func calculateAndSaveSentimentData(project: Project, completion: @escaping (Int?) -> Void) {
       
        sentimentManager.getSentimentScoreFor(string: "#\(project.rawValue)", completion: {
            (sentiment) -> Void in
            if sentiment != nil {
                self.persistencyManager.updateLocalSentimentData(project: project, sentiment: sentiment)
                self.persistencyManager.saveAllSentimentDataLocally()
                
                completion(sentiment)
            }
        })
        
        
    }
    
    func getAllSentimentData() -> AllSentimentData {
        return persistencyManager.getAllSentimentData()
    }
    
    func getSentimentData(project: Project) -> Int? {
        return persistencyManager.getSentimentData(project: project)
    }
    
    func updateLocalSentimentData(project: Project, sentiment: Int) {
        persistencyManager.updateLocalSentimentData(project: project, sentiment: sentiment)
    }
    
    func saveAllSentimentDataLocally() {
        persistencyManager.saveAllSentimentDataLocally()
    }
    
    
    /// - Mark: Get / Set / Locally Save RSI Data
    
    func getAllRsiData() -> AllRsiData {
        return persistencyManager.getAllRsiData()
    }
    
    func getRsiData(project: Project) -> Double? {
        return persistencyManager.getRsiData(project: project)
    }
    
    func updateLocalRsiData(project: Project, rsi: Double) {
       persistencyManager.updateLocalRsiData(project: project, rsi: rsi)
    }
    
    func updateLocalAllRsiData (allRsiData: AllRsiData) {
        /// TODO
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
    
    fileprivate func updateAllCurrentTickerPriceData(allCurrentTickerPriceData: AllCurrentTickerPriceData) {
        self.allCurrentTickerPriceData = allCurrentTickerPriceData
    }
    
    fileprivate func saveAllCurrentTickerPriceDataLocally() {
        DispatchQueue.main.async(execute: {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allCurrentTickerPriceData), forKey: "allCurrentTickerPriceData")
            print("allCurrentTickerPriceData locally saved.")
        })
    }
    
    fileprivate func retrieveSavedAllCurrentTickerPriceData(completion: @escaping (AllCurrentTickerPriceData?) -> Void) {
//        DispatchQueue.main.async(execute: {
            print("Retrieving Locally Saved Ticker Price Data")
            var priceData: AllCurrentTickerPriceData?
            if let data = UserDefaults.standard.value(forKey: "allCurrentTickerPriceData") as? Data {
                print("SUCCESS: Retrieving Locally Saved Ticker Price Data")
                priceData = try? PropertyListDecoder().decode(AllCurrentTickerPriceData.self, from: data)
                print("PRICEDATA: \(priceData)")
                completion(priceData)
            } else {
                print("FAILURE: Retrieving Locally Saved Ticker Price Data")
                completion(priceData)
            }
    }
    
    /// - Mark: Get / Set / Locally Save HISTORIC Price Data
    
    /// Not used atm
    fileprivate func getAllHistoricPriceData() -> AllHistoricPriceData {
        return allHistoricPriceData
    }
    
    fileprivate func getHistoricPriceData(project: Project) -> AggregatedHistoricPriceData? {
        return allHistoricPriceData.projectPriceDict[project]
    }
    
    /// Not used atm
    fileprivate func updateLocalHistoricPriceData(project: Project, aggregatedHistoricPriceData: AggregatedHistoricPriceData) {
        allHistoricPriceData.projectPriceDict.updateValue(aggregatedHistoricPriceData, forKey: project)
    }
    
    fileprivate func updateAllHistoricPriceData(allHistoricPriceData: AllHistoricPriceData) {
        self.allHistoricPriceData = allHistoricPriceData
    }
    
    fileprivate func updateLocalHistoricPriceData(project: Project, history: [History], period: Period) {

        var projectPriceDict = allHistoricPriceData.projectPriceDict
        
        /// If it doesn't contain key, we'll update it
        if allHistoricPriceData.projectPriceDict[project] == nil {
            let newAggregatedHistory = AggregatedHistoricPriceData()
            allHistoricPriceData.projectPriceDict.updateValue( newAggregatedHistory, forKey: project)
        }
        var aggregatedHistoryForProject = allHistoricPriceData.projectPriceDict[project]
        
        switch (period) {
        case .Alltime:
            aggregatedHistoryForProject?.alltimeHistoryArray = history as! [AlltimeHistory]
            break
        case .Daily:
            aggregatedHistoryForProject?.dailyHistoryArray = history as! [DailyHistory]
            break
        case .Monthly:
            aggregatedHistoryForProject?.monthlyHistoryArray = history as! [MonthlyHistory]
            break
        }
        allHistoricPriceData.projectPriceDict.updateValue(aggregatedHistoryForProject!, forKey: project)
    }
    
    fileprivate func saveAllHistoricPriceDataLocally() {
        DispatchQueue.main.async(execute: {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allHistoricPriceData), forKey: "allHistoricPriceData")
            print("allHistoricPriceData locally saved.")
        })
    }
    
    fileprivate func retrieveSavedAllHistoricPriceData(completion: @escaping (AllHistoricPriceData?) -> Void) {
            print("Retrieving Locally Saved Historic Price Data")
            var priceData: AllHistoricPriceData?
            if let data = UserDefaults.standard.value(forKey: "allHistoricPriceData") as? Data {
                print("SUCCESS: Retrieving Locally Saved Historic Price Data")
                priceData = try? PropertyListDecoder().decode(AllHistoricPriceData.self, from: data)
                print("PRICEDATA: \(priceData)")
                completion(priceData)
            } else {
                print("FAILURE: Retrieving Locally Saved Historic Price Data")
                completion(priceData)
            }
    }
    
    
    /// - Mark: Get / Set / Locally Save Sentiment Data
    
    fileprivate func getAllSentimentData() -> AllSentimentData {
        return allSentimentData
    }
    
    fileprivate func getSentimentData(project: Project) -> Int? {
        return allSentimentData.projectSentimentDict[project]
    }
    
    fileprivate func updateLocalSentimentData(project: Project, sentiment: Int) {
        allSentimentData.projectSentimentDict.updateValue(sentiment, forKey: project)
    }
    
    func updateLocalAllRsiData (allSentimentData: AllSentimentData) {
        self.allSentimentData = allSentimentData
    }
    
    fileprivate func saveAllSentimentDataLocally() {
        DispatchQueue.main.async(execute: {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allSentimentData), forKey: "allSentimentData")
            print("allSentimentData locally saved.")
        })
    }
    
    fileprivate func retrieveSavedAllSentimentData(completion: @escaping (AllSentimentData?) -> Void) {
        print("Retrieving Locally Saved AllSentimentData Data")
        var allSentimentData: AllSentimentData?
        if let data = UserDefaults.standard.value(forKey: "allSentimentData") as? Data {
            print("SUCCESS: Retrieving Locally Saved AllSentimentData")
            allSentimentData = try? PropertyListDecoder().decode(AllSentimentData.self, from: data)
            print("RSIData: \(allSentimentData)")
            completion(allSentimentData)
        } else {
            print("FAILURE: Retrieving Locally Saved AllSentimentData")
            completion(allSentimentData)
        }
    }
    
    
    
    /// - Mark: Get / Set / Locally Save RSI Data
    
    fileprivate func getAllRsiData() -> AllRsiData {
        return allRsiData
    }
    
    fileprivate func getRsiData(project: Project) -> Double? {
        return allRsiData.projectRsiDict[project]
    }
    
    fileprivate func updateLocalRsiData(project: Project, rsi: Double) {
        allRsiData.projectRsiDict.updateValue(rsi, forKey: project)
    }
    
    func updateLocalAllRsiData (allRsiData: AllRsiData) {
        self.allRsiData = allRsiData
    }
    
    fileprivate func saveAllRsiDataLocally() {
        DispatchQueue.main.async(execute: {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allRsiData), forKey: "allRsiData")
            print("AllRsiData locally saved.")
        })
    }
    
    fileprivate func retrieveSavedAllRsiData(completion: @escaping (AllRsiData?) -> Void) {
        print("Retrieving Locally Saved RSI Data")
        var rsiData: AllRsiData?
        if let data = UserDefaults.standard.value(forKey: "allRsiData") as? Data {
            print("SUCCESS: Retrieving Locally Saved RSI Data")
            rsiData = try? PropertyListDecoder().decode(AllRsiData.self, from: data)
            print("RSIData: \(rsiData)")
            completion(rsiData)
        } else {
            print("FAILURE: Retrieving Locally Saved RSI Data")
            completion(rsiData)
        }
    }
    
}


final class CurrentPriceSubscriptionManager {
    /// Allows to only observe one project at once
    private var timer: Timer?
    var callbacks: [((CurrentTickerPriceData) -> Void)]
    var currentlyObservedProject: Project?
    
    var priceWebservice = Webservice()
    
    fileprivate init() {
        callbacks = [((CurrentTickerPriceData) -> Void)]()
    }
    
    func activateSubscription() {
        guard currentlyObservedProject != nil && timer == nil else {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: Constants.updatePriceInSeconds, repeats: true) { [weak self] _ in

            self!.priceWebservice.getCurrentPriceData(dataProvider: .BitcoinAverage, project: self!.currentlyObservedProject!, completion: { currentPriceData -> Void in
                print("timer timing..")
                self!.executeCallbacks(currentPriceData: currentPriceData)
            } )
        }
    }
    
    func startSubscribingToPriceData(project: Project, completion: @escaping ((CurrentTickerPriceData) -> Void)) {
        ///Different or new Project - stop deactivate Subscription, start new one.
        if project != currentlyObservedProject {
            deactivateSubscriptionAndDeleteCallbacks()
            currentlyObservedProject = project
            callbacks.append(completion)
            activateSubscription()
            return
        }
        
        callbacks.append(completion)
    }
    
    private func executeCallbacks(currentPriceData: CurrentTickerPriceData) {
        print("Executing callbacks...")
        for callback in callbacks {
            print("Executing single callback")
            callback(currentPriceData)
        }
    }
    
    func deactivateSubscription() {
        timer?.invalidate()
        timer = nil
        currentlyObservedProject = nil
    }
    
    func deactivateSubscriptionAndDeleteCallbacks() {
        timer?.invalidate()
        timer = nil
        currentlyObservedProject = nil
        
        callbacks.removeAll()
    }
}
