//
//  HistoricPriceChartView.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//


import Foundation
import UIKit
import Charts

class ChartView: ChartViewDelegate {
    
    let chartView: LineChartView
    let chartPrices: [Double]
    
    
    func drawChart() {
        
        let values = chartPrices.enumerated().map { (index, data) -> ChartDataEntry in
            return ChartDataEntry(x: Double(index), y: data)
        }
        
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.drawGridBackgroundEnabled = true
        
        chartView.noDataFont = UIFont(name: "Helvetica", size: 20)!
        chartView.noDataTextColor = UIColor.white

        chartView.leftAxis.gridColor = UIColor.blueCardBackground
        chartView.xAxis.enabled = false
        chartView.leftAxis.labelTextColor = UIColor.subtitleBlue.withAlphaComponent(0.35)
        chartView.leftAxis.axisLineColor = .clear

        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        
        
        let dataSet = LineChartDataSet(values: values, label: nil)
        dataSet.lineWidth = 2
        dataSet.mode = .cubicBezier
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleRadius = 0
        dataSet.drawIconsEnabled = false
        dataSet.setColor(.lineColor) // UIColor.white
        dataSet.setCircleColor(.clear)
        
        let gradientColors = [UIColor.clear.cgColor,
                              UIColor.black.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        dataSet.fillAlpha = 0.1
        dataSet.fill = Fill(linearGradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true

        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
    
    
    init(chartView: LineChartView, chartValues: [Double]) {
        self.chartView = chartView
        self.chartPrices = chartValues
    }
}

