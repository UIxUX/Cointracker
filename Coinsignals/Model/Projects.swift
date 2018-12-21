//
//  Projects.swift
//  Coinsignals
//
//  Created by Julian Praest on 21.12.18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit


enum Project: String {
    case BTC
    case ETH
    case LTC
}

enum Fiat: String {
    case USD
}

extension Project {
    
    func unicode() -> String {
        switch self {
        case .BTC: return "₿"
        case .ETH: return "Ξ"
        case .LTC: return "Ł"
        }
    }
    
    func fittingColor() -> UIColor {
        switch self {
        case .BTC: return UIColor.white
        case .ETH: return UIColor.white
        case .LTC: return UIColor.white
        }
    }
}
