//
//  Router.swift
//  Coinsignals
//
//  Created by Julian Praest on 21.12.18.
//  Copyright © 2018 Org. All rights reserved.
//

import Foundation
import Alamofire

class Webservice {

    typealias getHistoricPriceDataCompletion = ([History]) -> Void
    typealias getCurrentPriceDataCompletion = (CurrentTickerPriceData) -> Void
    
    public func getHistoricPriceData(dataProvider: DataProvider, project: Project, period: Period, completion: @escaping getHistoricPriceDataCompletion) {
        switch dataProvider {
        case .BitcoinAverage:
            let url = BitcoinAverage.buildHistoryEndpointString(for: project, period: period, fiat: .USD)
            print(url)
            Alamofire.request(url).responseJSON(completionHandler: {
                response in
                if response.result.isSuccess {
                    guard response.error == nil, let json = response.data else {
                        return
                    }
                    do {
                        let decoder = ApiDecoder()
                        
                        var data: [History]?
                        switch period {
                            case .Daily:
                                data = try decoder.decode([DailyHistory].self, from: json)
                            case .Monthly:
                                data = try decoder.decode([MonthlyHistory].self, from: json)
                            case .Alltime:
                                data = try decoder.decode([AlltimeHistory].self, from: json)
                        }
                        if data != nil {
                            data!.sort(by: {$0.time < $1.time})
                            DispatchQueue.main.async(execute: {
                                completion(data!)
                            })
                            
                        }
                    } catch {
                        completion([])
                    }
                } else {
                    print(response.result.debugDescription)
                }
            })
        }
    }
    
    
    public func getCurrentPriceData(dataProvider: DataProvider, project: Project, completion: @escaping getCurrentPriceDataCompletion) {
        switch dataProvider {
        case .BitcoinAverage:
            let url = BitcoinAverage.buildCurrentPriceEndpointString(for: project)
            print(url)
            Alamofire.request(url).responseJSON(completionHandler: {
                response in
                if response.result.isSuccess {
                    guard response.error == nil, let json = response.data else {
                        return
                    }
                    do {
                        let decoder = ApiDecoder()
                        
                        let data = try decoder.decode(CurrentTickerPriceData.self, from: json)
                        
                        DispatchQueue.main.async(execute: {
//                            print(data)
                            completion(data)
                        })

                    } catch {
                        print("unable to decode currenttickerpricedata")
                    }
                } else {
                    print(response.result.debugDescription)
                }
            })
        }
    }
    
}
