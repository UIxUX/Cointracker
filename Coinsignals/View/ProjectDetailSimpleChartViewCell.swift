//
//  ProjectDetailSimpleChartViewCell.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit
import Charts

protocol ProjectDetailSimpleChartViewCellDelegate {
    func notifyPeriodButtonPressed(period: Period)
}

class ProjectDetailSimpleChartViewCell: UITableViewCell {
    
    var delegate: ProjectDetailSimpleChartViewCellDelegate?
    
    @IBOutlet weak var historicPricesChartView: LineChartView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var dailyButton: UIButton!
    
    @IBOutlet weak var monthlyButton: UIButton!
    
    @IBOutlet weak var alltimeButton: UIButton!
    
    override func awakeFromNib() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        historicPricesChartView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = true
//        self.backgroundColor = .clear
//        self.contentView.backgroundColor = .clear
        bringSubviewToFront(stackView)
    }
    
    @IBAction func dailyButtonPressed(_ sender: UIButton) {
        delegate?.notifyPeriodButtonPressed(period: .Daily)
    }
    @IBAction func monthlyButtonPressed(_ sender: UIButton) {
        delegate?.notifyPeriodButtonPressed(period: .Monthly)
    }
    @IBAction func alltimeButtonPressed(_ sender: UIButton) {
        delegate?.notifyPeriodButtonPressed(period: .Alltime)
    }
    
    
    
}
