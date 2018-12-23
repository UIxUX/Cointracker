//
//  Extensions.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit

enum Intensity {
    case Light
    case Medium
    case Strong
}

extension UIView {
    func applyShadow(intensity: Intensity) {
        switch intensity {
        case .Light:
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 8)
            layer.shadowOpacity = 0.1
            layer.shadowRadius = 18
        case .Strong:
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 8)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 18
        default:
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 8)
            layer.shadowOpacity = 0.18
            layer.shadowRadius = 18
        }
        
        layer.masksToBounds = false
        clipsToBounds = false
    }
    
    func makeRounded() {
        layer.cornerRadius = self.frame.height / 2
    }
    
    func makeCardRounded() {
        layer.cornerRadius = 20
    }
    
    func addGradient(colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        
        layer.insertSublayer(gradient, at: 0)
    }

}

extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 9.0
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
}
