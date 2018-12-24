//
//  ProjectDetailSimpleStackButtonsCell.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/24/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit

protocol ProjectDetailSimpleStackButtonsCellDelegate {
    func notifyPeriodButtonPressed(period: Period)
}

class ProjectDetailSimpleStackButtonsCell: UITableViewCell {
    
    var delegate: ProjectDetailSimpleStackButtonsCellDelegate?
    

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var dailyButton: UIButton!
    
    @IBOutlet weak var monthlyButton: UIButton!
    
    @IBOutlet weak var alltimeButton: UIButton!
    
    override func awakeFromNib() {
       backgroundColor = UIColor.black.withAlphaComponent(0.1)
        dailyButton.setTitleColor(UIColor.redAlert, for: .normal)
        monthlyButton.setTitleColor(UIColor.subtitleBlue, for: .normal)
        alltimeButton.setTitleColor(UIColor.subtitleBlue, for: .normal)
        
        dailyButton.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        monthlyButton.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        alltimeButton.backgroundColor = UIColor.white.withAlphaComponent(0.0)
    }
    
    @IBAction func dailyButtonPressed(_ sender: UIButton) {
        delegate?.notifyPeriodButtonPressed(period: .Daily)
        setSelected (button: sender)
    }
    @IBAction func monthlyButtonPressed(_ sender: UIButton) {
        delegate?.notifyPeriodButtonPressed(period: .Monthly)
        setSelected (button: sender)
    }
    @IBAction func alltimeButtonPressed(_ sender: UIButton) {
        delegate?.notifyPeriodButtonPressed(period: .Alltime)
        setSelected (button: sender)
    }
    
    func setSelected (button: UIButton) {
        VibrationManager.vibrateOnce()
        dailyButton.setTitleColor(UIColor.subtitleBlue, for: .normal)
        monthlyButton.setTitleColor(UIColor.subtitleBlue, for: .normal)
        alltimeButton.setTitleColor(UIColor.subtitleBlue, for: .normal)
        
        button.setTitleColor(UIColor.redAlert, for: .normal)
    }
    
    
    
}
