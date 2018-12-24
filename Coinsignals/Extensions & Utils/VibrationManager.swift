//
//  VibrationManager.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/24/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit
import AudioToolbox

struct VibrationManager {
    
    static func vibrateOnce() {
        let model = UIDevice.current.modelName
        switch model {
        case "iPhone 7", "iPhone 7 Plus", "iPhone 8", "iPhone 8 Plus", "iPhone X":
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            
            generator.impactOccurred()
        default:
            AudioServicesPlaySystemSound(1519)
        }
    }
}
