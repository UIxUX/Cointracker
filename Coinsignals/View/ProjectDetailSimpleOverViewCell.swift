//
//  ProjectDetailSimpleOverViewCell.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit

class ProjectDetailSimpleOverViewCell: UITableViewCell {

    @IBOutlet weak var cardView: ForceTouchButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rsiLabel: UILabel!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    @IBOutlet weak var priceChangedButton: UIButton!
    @IBOutlet weak var rsiValueButton: UIButton!
    @IBOutlet weak var sentimentValueButton: UIButton!
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        backgroundColor = .clear
        cardView.backgroundColor = UIColor.blueCardBackground
        cardView.makeCardRounded()
        cardView.applyShadow(intensity: .Strong)
        
        setPriceLabel(string: "price n.a.")
        priceLabel.textDropShadow()
        
        rsiLabel.textColor = UIColor.subtitleBlue
        sentimentLabel.textColor = UIColor.subtitleBlue
        
        priceChangedButton.backgroundColor = UIColor.blueBubble
        rsiValueButton.backgroundColor = UIColor.blueBubble
        sentimentValueButton.backgroundColor = UIColor.blueBubble
        
        priceChangedButton.isUserInteractionEnabled = false
        rsiValueButton.isUserInteractionEnabled = false
        sentimentValueButton.isUserInteractionEnabled = false
        
        priceChangedButton.makeRounded()
        rsiValueButton.makeRounded()
        sentimentValueButton.makeRounded()
    }
    
    
    func setPriceLabel(string: String) {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.3), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica-Bold", size: 30.0)!, range: NSMakeRange(0, (attributedString.length)))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(white: 1.0, alpha: 1.00), range: NSMakeRange(0, (attributedString.length)))
        
        priceLabel.attributedText = attributedString
    }
    
    func setBubbleText(string: String, bubble: UIButton, success: Bool? = true) {
        let successColor = success == true ? UIColor.greenSuccess : UIColor.redAlert
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.3), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica-Bold", size: 9.0)!, range: NSMakeRange(0, (attributedString.length)))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: successColor, range: NSMakeRange(0, (attributedString.length)))
        
        bubble.setAttributedTitle(attributedString, for: .normal)
    }
}
