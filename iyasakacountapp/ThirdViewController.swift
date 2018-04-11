//
//  ThirdViewController.swift
//  iyasakacountapp
//
//  Created by 八重尾 立志 on 2018/04/06.
//  Copyright © 2018年 Yaeo Tateshi. All rights reserved.
//

import UIKit
import Charts

class ThirdViewController: UIViewController {
    
    //secondからの引き継ぎ
    var setAge: [[Double]] = [[0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0]]
  
    let time = ["15-17", "17-19", "19-21", "21-23", "23-25"]
    lazy var unitsAge = setAge
    
    
    @IBOutlet weak var chartAge: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chartAge.noDataText = "You need to provide data for the chart."
        chartAge.chartDescription?.text = "年齢"
        
        let xaxis = chartAge.xAxis
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.time)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = chartAge.leftAxis
        yaxis.spaceTop = 0.15
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = true
        
        chartAge.rightAxis.enabled = false
        
        chartAge.pinchZoomEnabled = false
        chartAge.doubleTapToZoomEnabled = false
        chartAge.dragEnabled = false
        chartAge.drawBarShadowEnabled = false
        chartAge.drawBordersEnabled = true
        
        setChart()

        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart() {
        chartAge.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0...4 {
            //stack barchart
            let dataEntry = BarChartDataEntry(x: Double(i), yValues:  [self.unitsAge[i][0],self.unitsAge[i][1],self.unitsAge[i][2],self.unitsAge[i][3],self.unitsAge[i][4],self.unitsAge[i][5]])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = [UIColor.cyan,UIColor.green,UIColor.yellow,UIColor.orange,UIColor.magenta,UIColor.red]
        chartDataSet.stackLabels = ["〜小学生", "中学生","16〜24","25〜39","40〜59","60〜"]
        
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let groupSpace = 0.4
        let barSpace = 0.05
        let barWidth = 0.5
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = self.time.count
        let startYear = 0
        
        chartData.barWidth = barWidth;
        chartAge.xAxis.axisMinimum = Double(startYear) - 0.5
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        chartAge.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        chartAge.notifyDataSetChanged()
        
        chartAge.data = chartData
        
        
        //background color
        chartAge.backgroundColor = UIColor.white
        
        //chart animation
        chartAge.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
