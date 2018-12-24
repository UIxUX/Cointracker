//
//  RsiData.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/22/18.
//  Copyright © 2018 Org. All rights reserved.
//

import Foundation

struct AllRsiData: Codable {
    var projectRsiDict: Dictionary<Project,Double>
    
    init() {
        projectRsiDict = Dictionary<Project,Double>()
    }
}

enum Rsi: String, Codable {
    case Oversold
    case Neutral
    case Oberbought
}
