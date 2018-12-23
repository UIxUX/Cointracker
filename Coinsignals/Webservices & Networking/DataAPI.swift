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
        
        pManager.retrieveSavedAllCurrentTickerPriceData(completion: {(savedAllCurrentTickerPriceData) -> Void in
            if savedAllCurrentTickerPriceData != nil {
                pManager.updateAllCurrentTickerPriceData(allCurrentTickerPriceData: savedAllCurrentTickerPriceData!)
            }
        })
        
        return pManager
    }()
    
    private let currentPriceSubscriptionManager = CurrentPriceSubscriptionManager()
    
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
        DispatchQueue.main.async(execute: {
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
        })
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
            print("halligalli")
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
