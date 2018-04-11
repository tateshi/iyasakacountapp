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
    
    //チャート
    @IBOutlet weak var chartAge: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chartAge.noDataText = "You need to provide data for the chart."
        chartAge.chartDescription?.text = "年齢"
    //x軸の設定
        let xaxis = chartAge.xAxis
        //x軸のグリッドライン非表示
        xaxis.drawGridLinesEnabled = false
        //x軸ラベルの位置
        xaxis.labelPosition = .bottom
        //x軸のvalueをセット
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.time)
        //x軸の粒度
        xaxis.granularity = 1
        
    //y軸の設定
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        let yaxis = chartAge.leftAxis
        //上部の余白
        yaxis.spaceTop = 0.15
        //y軸の最小値を固定
        yaxis.axisMinimum = 0
        //y軸のグリッドライン表示
        yaxis.drawGridLinesEnabled = true
    
    //その他の設定
        //右側のラベル非表示
        chartAge.rightAxis.enabled = false
        //ピンチズーム無効
        chartAge.pinchZoomEnabled = false
        //ダブルタップズーム無効
        chartAge.doubleTapToZoomEnabled = false
        //ドラッグ無効
        chartAge.dragEnabled = false
        //グラフの影無効
        chartAge.drawBarShadowEnabled = false
        //グラフの枠非表示
        chartAge.drawBordersEnabled = false
        
        setChart()

        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart() {
        chartAge.noDataText = "You need to provide data for the chart."
        
        //棒グラフのデータを入れる配列
        var dataEntries: [BarChartDataEntry] = []
        //配列にデータを入れるループ処理
        for i in 0...4 {
            //stacked barchart
            let dataEntry = BarChartDataEntry(x: Double(i), yValues:  [self.setAge[i][0],self.setAge[i][1],self.setAge[i][2],self.setAge[i][3],self.setAge[i][4],self.setAge[i][5]])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        //整数にするためのフォーマッター
        chartDataSet.valueFormatter = BarChartValueFormatter()
        //チャートの配色・ラベル
        chartDataSet.colors = [UIColor(red: 255/255, green: 255/255, blue: 127/255, alpha: 1),UIColor(red: 127/255, green: 255/255, blue: 191/255, alpha: 1),UIColor(red: 127/255, green: 191/255, blue: 255/255, alpha: 1),UIColor(red: 191/255, green: 127/255, blue: 255/255, alpha: 1),UIColor(red: 255/255, green: 127/255, blue: 191/255, alpha: 1),UIColor(red: 255/255, green: 127/255, blue: 127/255, alpha: 1)]
        chartDataSet.stackLabels = ["〜小学生", "中学生","16〜24","25〜39","40〜59","60〜"]
        
    //グラフのUI
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


