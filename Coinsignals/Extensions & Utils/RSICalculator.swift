//
//  RSICalculator.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/24/18.
//  Copyright © 2018 Org. All rights reserved.
//

import Foundation

/// Ref: https://codereview.stackexchange.com/questions/183875/relative-strength-index/183880#183880

struct RSICalculator {
    static func calculateRSI(data: [History]) -> Double {
        
        let period = data.count - 2
        
        // Upward Movements and Downward Movements
        var upwardMovements: [Double] = []
        var downwardMovements: [Double] = []
        
        for (prev, now) in zip(data, data.dropFirst()) {
            let diff = now.average - prev.average
            upwardMovements.append(max(diff, 0))
            downwardMovements.append(max(-diff, 0))
        }
        
        // Average Upward Movements and Average Downward Movements
        let averageUpwardMovement1 = upwardMovements[0..<period].reduce(0, +) / Double(period)
        let averageDownwardMovement1 = downwardMovements[0..<period].reduce(0, +) / Double(period)
        
        let averageUpwardMovement2 = (averageUpwardMovement1 * Double(period - 1) + upwardMovements[period]) / Double(period)
        let averageDownwardMovement2 = (averageDownwardMovement1 * Double(period - 1) + downwardMovements[period]) / Double(period)
        
        // Relative Strength
        let relativeStrength1 = averageUpwardMovement1 / averageDownwardMovement1
        let relativeStrength2 = averageUpwardMovement2 / averageDownwardMovement2
        
        // Relative Strength Index
        let rSI1 = 100 - (100 / (relativeStrength1 + 1))
        let rSI2 = 100 - (100 / (relativeStrength2 + 1))
        
        // Relative Strength Index Average
        let rsiAverage = (rSI1 + rSI2) / 2
        
        return rsiAverage
    }
}
