//
//  SentimentData.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/22/18.
//  Copyright © 2018 Org. All rights reserved.
//

import Foundation

struct AllSentimentData: Codable {
    var projectSentimentDict: Dictionary<Project,Int>
    
    init() {
        projectSentimentDict = Dictionary<Project,Int>()
    }
}

enum Sentiment: String, Codable {
    case ExtremelyGood
    case VeryGood
    case Neutral
    case Bad
    case VeryBad
    case ExtremelyBad
}
