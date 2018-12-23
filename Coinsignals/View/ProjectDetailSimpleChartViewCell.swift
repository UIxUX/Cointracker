//
//  ProjectDetailSimpleChartViewCell.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit
import Charts

class ProjectDetailSimpleChartViewCell: UITableViewCell {
    
    @IBOutlet weak var historicPricesChartView: LineChartView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
}
