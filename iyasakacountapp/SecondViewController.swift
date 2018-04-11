//
//  SecondViewController.swift
//  iyasakacountapp
//
//  Created by 八重尾 立志 on 2018/04/06.
//  Copyright © 2018年 Yaeo Tateshi. All rights reserved.
//

import UIKit
import Charts

class SecondViewController: UIViewController {
    //firstからの引き継ぎ
    var setMale: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0]
    var setFemale: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0]
    var setAge: [[Double]] = [[]]

    let time = ["15-17", "17-19", "19-21", "21-23", "23-25"]
    lazy var unitsMale = setMale
    lazy var unitsFemale = setFemale
    
    
    //戻る遷移のための設定
    @IBAction func returnToSec(segue: UIStoryboardSegue) {}

    //チャート
    @IBOutlet weak var chartSex: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //chartSex.delegate = self
        chartSex.noDataText = "You need to provide data for the chart."
        chartSex.chartDescription?.text = "性別"
        
        let xaxis = chartSex.xAxis
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.time)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = chartSex.leftAxis
        yaxis.spaceTop = 0.15
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = true
        
        chartSex.rightAxis.enabled = false
        
        chartSex.pinchZoomEnabled = false
        chartSex.doubleTapToZoomEnabled = false
        chartSex.dragEnabled = false
        chartSex.drawBarShadowEnabled = false
        chartSex.drawBordersEnabled = true
        
        setChart()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart() {
        chartSex.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0...4 {
            //stack barchart
            let dataEntry = BarChartDataEntry(x: Double(i), yValues:  [self.unitsMale[i],self.unitsFemale[i]])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = [UIColor.blue,UIColor.red]
        chartDataSet.stackLabels = ["男", "女"]
        
        
        let chartData = BarChartData(dataSet: chartDataSet)
        let groupSpace = 0.4
        let barSpace = 0.05
        let barWidth = 0.5
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = self.time.count
        let startYear = 0
        
        chartData.barWidth = barWidth;
        chartSex.xAxis.axisMinimum = Double(startYear) - 0.5
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        chartSex.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        chartSex.notifyDataSetChanged()
        
        chartSex.data = chartData
        
        
        //background color
        chartSex.backgroundColor = UIColor.white
        
        //chart animation
        chartSex.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
        
    }
    
    //thirdへの引き継ぎ
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goThird" {
            let thirdVc = segue.destination as! ThirdViewController
            thirdVc.setAge = self.setAge
        }else {
        }
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




