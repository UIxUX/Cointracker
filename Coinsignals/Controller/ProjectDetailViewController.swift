//
//  ProjectDetailViewController.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit
import Charts

class ProjectDetailViewController: UITableViewController {
    
    var selectedProject: Project!
    var selectedPeriod: Period!
    
    var headerCell: ProjectDetailHeaderViewCell?
    var projectDetailSimpleOverViewCell: ProjectDetailSimpleOverViewCell?
    var projectDetailSimpleChartViewCell: ProjectDetailSimpleChartViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        selectedProject = .BTC
        selectedPeriod = .Daily
        
        /// Async Retrieval of external Data to get more Actualized Data
        DataAPI.shared.getExternalCurrentTickerPriceData(project: selectedProject, completion: {
            (currentPriceData) -> Void in
            self.setCurrentPriceData(currentPriceData: currentPriceData, _projectDetailSimpleOverViewCell: self.projectDetailSimpleOverViewCell)
            
            if let rsi = DataAPI.shared.getRsiData(project: self.selectedProject) {
                self.setRsiData(rsi: rsi, _projectDetailSimpleOverViewCell: self.projectDetailSimpleOverViewCell)
            }
        })
        
        /// Starts Subscription to Price Ticker
        startSubscribingToCurrentPrice()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    fileprivate func startSubscribingToCurrentPrice() {
        DataAPI.shared.startExternalCurrentTickerPriceDataSubscription(project: selectedProject, completion: {
            (currentPriceData) -> Void in
            self.setCurrentPriceData(currentPriceData: currentPriceData, _projectDetailSimpleOverViewCell: self.projectDetailSimpleOverViewCell)
        })
    }
    
    private func setRsiData(rsi: Double, _projectDetailSimpleOverViewCell: ProjectDetailSimpleOverViewCell?) {
        if _projectDetailSimpleOverViewCell != nil {
            if rsi >= 70 {
                _projectDetailSimpleOverViewCell!.setBubbleText(string: "OVERBOUGHT (\(Int(rsi)))", bubble: ((_projectDetailSimpleOverViewCell!.rsiValueButton)!), success: false)
            } else if rsi <= 30 {
                _projectDetailSimpleOverViewCell!.setBubbleText(string: "OVERSOLD (\(Int(rsi)))", bubble: ((_projectDetailSimpleOverViewCell!.rsiValueButton)!), success: true)
            } else {
                _projectDetailSimpleOverViewCell!.setBubbleText(string: "NEUTRAL (\(Int(rsi)))", bubble: ((_projectDetailSimpleOverViewCell!.rsiValueButton)!), success: true, neutral: true)
            }
        }
    }
    
    private func setCurrentPriceData(currentPriceData: CurrentTickerPriceData, _projectDetailSimpleOverViewCell: ProjectDetailSimpleOverViewCell?) {
        if _projectDetailSimpleOverViewCell != nil {
            _projectDetailSimpleOverViewCell!.setPriceLabel(string: "\(currentPriceData.last)$")
            
            switch (self.selectedPeriod!) {
            case .Alltime:
                let percent = currentPriceData.changes.percent.year
                let overZero = percent >= 0.0 ? true : false
                _projectDetailSimpleOverViewCell!.setBubbleText(string: "\(percent)% 1Y", bubble: ((_projectDetailSimpleOverViewCell!.priceChangedButton)!), success: overZero)
                break
            case .Daily:
                let percent = currentPriceData.changes.percent.day
                let overZero = percent >= 0.0 ? true : false
                _projectDetailSimpleOverViewCell!.setBubbleText(string: "\(percent)% 1D", bubble: ((_projectDetailSimpleOverViewCell!.priceChangedButton)!), success: overZero)
                
                break
            case .Monthly:
                let percent = currentPriceData.changes.percent.month
                let overZero = percent >= 0.0 ? true : false
                _projectDetailSimpleOverViewCell!.setBubbleText(string: "\(percent)% 1M", bubble: ((_projectDetailSimpleOverViewCell!.priceChangedButton)!), success: overZero)
                
                break
            }

        }
    }
    
    fileprivate func drawChartFromExternalData(period: Period) {
        if projectDetailSimpleChartViewCell != nil {
            var chartPrices = [Double]()

            DataAPI.shared.getExternalPriceHistoryData(project: selectedProject, period: period, completion: {
                (historicPrices) -> Void in
                chartPrices = historicPrices.flatMap({ $0.average })
                let chartView = ChartView(chartView: self.projectDetailSimpleChartViewCell!.historicPricesChartView, chartValues: chartPrices)
                chartView.drawChart()

                if let rsi = DataAPI.shared.getRsiData(project: self.selectedProject) {
                    self.setRsiData(rsi: rsi, _projectDetailSimpleOverViewCell: self.projectDetailSimpleOverViewCell)
                }
            })
        }
    }
    
    fileprivate func drawChartFromLocalData(period: Period, aggregatedHistoricPriceData: AggregatedHistoricPriceData, chartView: LineChartView) {
            var chartPrices = [Double]()
            
            switch (self.selectedPeriod!) {
            case .Daily:
                chartPrices = aggregatedHistoricPriceData.dailyHistoryArray.flatMap({ $0.average })
                break
            case .Monthly:
                chartPrices = aggregatedHistoricPriceData.monthlyHistoryArray.flatMap({ $0.average })
                break
            case .Alltime:
                chartPrices = aggregatedHistoricPriceData.alltimeHistoryArray.flatMap({ $0.average })
                break
            }
            let chartView = ChartView(chartView: chartView, chartValues: chartPrices)
            chartView.drawChart()
    }
    
    fileprivate func drawChartFromLocalData(period: Period) {
        if projectDetailSimpleChartViewCell != nil {
            var chartPrices = [Double]()
            
            /// TODO
        }
    }
    
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
        let gradientView = UIView(frame: self.view.frame)
        gradientView.addGradient(colors: [UIColor.blueBackgroundTop.cgColor, UIColor.blueBackgroundBottom.cgColor])
        tableView.backgroundView = gradientView
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 200))
        
        let row = indexPath.row
        switch row {
        case 0:
            ///HeaderCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailHeaderViewCell", for: indexPath)
            cell.frame.size.width = self.tableView.frame.width
            if let _cell = cell as? ProjectDetailHeaderViewCell {
                _cell.delegate = self
                _cell.setProjectLabel(string: "BTC")
                _cell.projectImageViewLabel.text = selectedProject.unicode()
                headerCell = _cell
            }
            break
        case 1:
            ///ProjectDetailSimpleOverViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailSimpleOverViewCell", for: indexPath)
            if let _cell = cell as? ProjectDetailSimpleOverViewCell {
                _cell.setPriceLabel(string: "4132$")
                _cell.setBubbleText(string: "+15%", bubble: _cell.priceChangedButton)
                _cell.setBubbleText(string: "OVERSOLD", bubble: _cell.rsiValueButton)
                
                if let locallySavedTickerData = DataAPI.shared.getLocalCurrentTickerPriceData(project: selectedProject) {
                    self.setCurrentPriceData(currentPriceData: locallySavedTickerData, _projectDetailSimpleOverViewCell: _cell)
                }
                
                if let rsi = DataAPI.shared.getRsiData(project: self.selectedProject) {
                    self.setRsiData(rsi: rsi, _projectDetailSimpleOverViewCell: self.projectDetailSimpleOverViewCell)
                }
               
                _cell.setBubbleText(string: "GREAT", bubble: _cell.sentimentValueButton)
                projectDetailSimpleOverViewCell = _cell
            }
            break
        case 2:
            ///ProjectDetailSimpleChartViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailSimpleChartViewCell", for: indexPath)
            if let _cell = cell as? ProjectDetailSimpleChartViewCell {
                
                if let locallySavedHistoricData = DataAPI.shared.getHistoricPriceData(project: selectedProject) {
                    drawChartFromLocalData(period: selectedPeriod, aggregatedHistoricPriceData: locallySavedHistoricData, chartView: _cell.historicPricesChartView)
                }
                
                projectDetailSimpleChartViewCell = _cell
                drawChartFromExternalData(period: selectedPeriod)
            }
            break
        case 3:
            ///ProjectDetailSimpleStackButtonsCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailSimpleStackButtonsCell", for: indexPath)
            if let _cell = cell as? ProjectDetailSimpleStackButtonsCell {
              _cell.delegate = self
            }
            break
        default:
            break
        }
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return 400
        default:
            return UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    //Hides status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}



extension ProjectDetailViewController: ProjectDetailSimpleStackButtonsCellDelegate {
    func notifyPeriodButtonPressed(period: Period) {
        selectedPeriod = period
        if let newPriceData = DataAPI.shared.getLocalCurrentTickerPriceData(project: selectedProject) {
            self.setCurrentPriceData(currentPriceData: newPriceData, _projectDetailSimpleOverViewCell: self.projectDetailSimpleOverViewCell)
            drawChartFromExternalData(period: selectedPeriod)
        }
    }
    
}

extension ProjectDetailViewController: ProjectDetailHeaderViewCellDelegate {
    func notifyProjectChangeButtonPressed() {
        let alert = UIAlertController(style: .actionSheet, title: "Choose a different Project 💎")
        alert.setTitle(font: .systemFont(ofSize: 20), color: .black)
        alert.setMessage(font: .systemFont(ofSize: 16), color: .black)
        alert.addAction(image: nil, title: "Bitcoin", color: .black, style: .default) { action in
            self.switchProject(newProject: .BTC)
        }
        alert.addAction(image: nil, title: "Ethereum", color: .black, style: .default) { action in
            self.switchProject(newProject: .ETH)
        }
        alert.addAction(image: nil, title: "Litecoin", color: .black, style: .default) { action in
            self.switchProject(newProject: .LTC)
        }
        alert.addAction(image: nil, title: "Cancel", color: .redAlert, style: .default) { action in
            /// Do nothing
        }
        alert.show(animated: true, vibrate: false) {
        }
    }
    
    func switchProject(newProject: Project) {
        self.selectedProject = newProject
        self.headerCell?.projectImageViewLabel.text = newProject.unicode()
        self.headerCell?.projectLabel.text = newProject.rawValue
        if let locallySavedHistoricData = DataAPI.shared.getHistoricPriceData(project: selectedProject) {
            
            drawChartFromLocalData(period: selectedPeriod, aggregatedHistoricPriceData: locallySavedHistoricData, chartView: (self.projectDetailSimpleChartViewCell?.historicPricesChartView)!)
        }
        startSubscribingToCurrentPrice()
        drawChartFromExternalData(period: selectedPeriod)
        
        if let rsi = DataAPI.shared.getRsiData(project: self.selectedProject) {
            self.setRsiData(rsi: rsi, _projectDetailSimpleOverViewCell: self.projectDetailSimpleOverViewCell)
        }
    }
}
