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
    
    //戻る遷移のための設定
    @IBAction func returnToSec(segue: UIStoryboardSegue) {}

    //チャート
    @IBOutlet weak var chartSex: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chartSex.noDataText = "You need to provide data for the chart."
        chartSex.chartDescription?.text = "性別"
        
    //x軸の設定
        let xaxis = chartSex.xAxis
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
        let yaxis = chartSex.leftAxis
        //上部の余白
        yaxis.spaceTop = 0.15
        //y軸の最小値を固定
        yaxis.axisMinimum = 0
        //y軸のグリッドライン表示
        yaxis.drawGridLinesEnabled = true
    
    //その他の設定
        //右側のラベル非表示
        chartSex.rightAxis.enabled = false
        //ピンチズーム無効
        chartSex.pinchZoomEnabled = false
        //ダブルタップズーム無効
        chartSex.doubleTapToZoomEnabled = false
        //ドラッグ無効
        chartSex.dragEnabled = false
        //グラフの影無効
        chartSex.drawBarShadowEnabled = false
        //グラフの枠非表示
        chartSex.drawBordersEnabled = false
        
        setChart()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setChart() {
        chartSex.noDataText = "You need to provide data for the chart."
        
        //棒グラフのデータを入れる配列
        var dataEntries: [BarChartDataEntry] = []
        //配列にデータを入れるループ処理
        for i in 0...4 {
            //stacked barchart
            let dataEntry = BarChartDataEntry(x: Double(i), yValues:  [self.setMale[i],self.setFemale[i]])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        //整数にするためのフォーマッター
        chartDataSet.valueFormatter = BarChartValueFormatter()
        //チャートの配色・ラベル
        chartDataSet.colors = [UIColor(red: 127/255, green: 255/255, blue: 255/255, alpha: 1),UIColor(red: 255/255, green: 163/255, blue: 255/255, alpha: 1)]
        chartDataSet.stackLabels = ["男", "女"]
        
    //グラフのUI
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

//小数点表示を整数表示にする処理。バーの上部に表示される数字。
class BarChartValueFormatter : NSObject, IValueFormatter {
    
    // This method is  called when a value (from labels inside the chart) is formatted before being drawn.
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let digitWithoutFractionValues = String(format: "%.0f", value)
        return digitWithoutFractionValues
    }
}



