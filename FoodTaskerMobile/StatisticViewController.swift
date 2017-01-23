//
//  StatisticViewController.swift
//  FoodTaskerMobile
//
//  Created by Daniel Cleaves on 1/20/17.
//  Copyright © 2017 Daniel Cleaves. All rights reserved.
//

import UIKit
import Charts

class StatisticViewController: UIViewController {
    @IBOutlet weak var viewChart: BarChartView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var weekdays = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        // #1 Initialize Charts
        self.initializeChart()
        
        
        // #2 Load data to shart
        self.loadDataToChart()
    }
    
    func initializeChart() {
        viewChart.noDataText = "No Data"
        viewChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        viewChart.xAxis.labelPosition = .bottom
        viewChart.descriptionText = ""
        viewChart.xAxis.setLabelCount(0, force: true)
        
        viewChart.legend.enabled = false
        viewChart.scaleYEnabled =  false
        viewChart.scaleXEnabled = false
        viewChart.pinchZoomEnabled = false
        viewChart.doubleTapToZoomEnabled = false
        
        viewChart.leftAxis.axisMinimum = 0.0
        viewChart.leftAxis.axisMaximum = 100.00
        viewChart.highlighter = nil
        viewChart.rightAxis.enabled = false
        viewChart.xAxis.drawGridLinesEnabled = false
        
        
    }
    
    func loadDataToChart() {
        APIManager.shared.getDriverRevenue { (json) in
            if json != nil {
                let revenue = json["revenue"]
                
                var dataEntries: [BarChartDataEntry] = Array()
                
                for i in 0..<self.weekdays.count {
                    let day = self.weekdays[i]
                    let dataEntry = BarChartDataEntry(x: revenue[day].double!, y: Double(i))
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "Revenue by day")
                chartDataSet.colors = ChartColorTemplates.material()
                
                let chartData = BarChartData(dataSet: chartDataSet)
                
                self.viewChart.data = chartData
            }
        }
    }

}
