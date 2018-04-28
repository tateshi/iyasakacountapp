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
    
    let time = ["15-17", "17-19", "19-21", "21-23", "23-25"]
    
    // チャートUI用の定数
    let groupSpace = 0.4
    let barSpace = 0.05
    let barWidth = 0.5
    let groupCount = 5
    let startYear = 0
    
    //firstからの引き継ぎ
    var unitsSet:[[Int]] = [[]]
    //チャート用の配列
    //性別
    var setMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var setFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    //年齢構成
    var setAge = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]
    
    //datePickerが呼び出された回数
    var flag = 0
    //指定集計時の開始日を固定する
    var firstDate = Date()
    //modalからの引き継ぎ
    var textFromModal = "日計" {
        didSet {
            if textFromModal == "指定"{
                firstDate = dateFromModal
            }
            // 値が更新されたらチャートも更新する
            updateChart()
        }
    }
    
    var dateFromModal = Date() {
        didSet {
            if textFromModal == "指定"{
                //終了日のdatePickarを呼び出す
                if flag == 1{
                    firstDate = dateFromModal
                    // 0.5秒後に実行したい処理
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.performSegue(withIdentifier: "godatepicker", sender: nil)
                    }
                }else{
                    updateChart()
                }
            }
            else{
            updateChart()
            }
        }
    }


    @IBOutlet weak var term: UIButton!
    @IBOutlet weak var dateLabel: UIButton!
    //性別表示
    @IBAction func Sexview(_ sender: Any) {
        //アニメーション
        UIView.transition(with: chartSex, duration: 1.0, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
        setChart()
    }
    //年齢表示
    @IBAction func Ageview(_ sender: Any) {
        UIView.transition(with: chartAge, duration: 1.0, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
        setChart2()
    }
    //チャート
    @IBOutlet weak var chartSex: BarChartView!
    @IBOutlet weak var chartAge: BarChartView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //日付表示の行数
        dateLabel.titleLabel?.numberOfLines = 2
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
        
        xaxis.axisMinimum = Double(startYear) - 0.5
        
    //y軸の設定
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        let yaxis = chartSex.leftAxis
        //上部の余白
        yaxis.spaceTop = 0.2
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
        //background color
        chartSex.backgroundColor = UIColor.white
        chartSex.notifyDataSetChanged()

        updateChart()
    }

    
// チャートにデータを入れて描画する一連の処理
    func updateChart(){
        if textFromModal == "週間"{
            makeWeeklyUnits()
        }else if textFromModal == "月間"{
            makeMonthlyUnits()
        }else if textFromModal == "指定"{
            makeOriginalUnits()
        }else{
            makeDailyUnits()
        }
        flag = 0
        term.setTitle(textFromModal, for: .normal)
        setChartData()
        setChart()
    }
    
// 保存データを呼び出して集計する
    func makeDailyUnits(){
        let dateStr = convertDateFormat(date: dateFromModal, key: "label")
        if  UserDefaults.standard.object(forKey: dateStr + "unitsSet") != nil {
            unitsSet = UserDefaults.standard.object(forKey: dateStr + "unitsSet") as! [[Int]]
        }else{
            unitsSet = [[],[],[],[],[]]
        }
        dateLabel.setTitle(convertDateFormat(date: dateFromModal, key: "date"), for: .normal)
    }
    
    func makeWeeklyUnits(){
        unitsSet = [[], [], [], [], []]
        let monday = searchWeek(date: dateFromModal)
        let sunday = Date(timeInterval: +60*60*24*6, since: monday)
        setTotal(date1: monday, date2: sunday)
        dateLabel.setTitle(convertDateFormat(date: monday, key: "date") + "\n　~　" + convertDateFormat(date: sunday, key: "date"), for: .normal)
    }
    
    func makeMonthlyUnits(){
        unitsSet = [[], [], [], [], []]
        let calendar = Calendar.current
        // 月初
        let comps = calendar.dateComponents([.year, .month], from: dateFromModal)
        let firstday = calendar.date(from: comps)
        setTotal(date1: firstday!, setint: 31)
        dateLabel.setTitle(convertDateFormat(date: dateFromModal, key: "month"), for: .normal)
    }
    
    func makeOriginalUnits(){
        unitsSet = [[], [], [], [], []]
        setTotal(date1: firstDate, date2:dateFromModal)
        dateLabel.setTitle(convertDateFormat(date: firstDate, key: "date") + "\n　~　" + convertDateFormat(date: dateFromModal, key: "date"), for: .normal)
    }
    
    //date1からdate2まで（date1からsetint日間）のデータを集計する
    func setTotal(date1:Date, date2:Date? = nil, setint:Int = 0){
        var interval = setint - 1
        // 日数の計算
        if date2 != nil{
            interval = Int(date2!.timeIntervalSince(date1) / (60*60*24))
        }
        for i in 0...interval{
            let dateStr = convertDateFormat(date: Date(timeInterval: +60*60*24*Double(i), since: date1), key: "label")
            if  UserDefaults.standard.object(forKey: dateStr + "unitsSet") != nil {
                for j in 0...4{
                    let joinSet = UserDefaults.standard.object(forKey: dateStr + "unitsSet") as! [[Int]]
                    unitsSet[j] += joinSet[j]
                }
            }
        }
    }

    // dateから指定のフォーマットのstringに変換する
    func convertDateFormat(date:Date, key:String) -> String {
        let outFormatter = DateFormatter()
        if key == "label"{
            outFormatter.dateFormat = "yyyyMMdd"
        }else if key == "date"{
            outFormatter.dateFormat = "yyyy/M/dd"
        }else if key == "month"{
            outFormatter.dateFormat = "yyyy/M"
        }
        return outFormatter.string(from: date)
    }
    
    // 月曜日を探す
    func searchWeek(date:Date) -> Date{
        let calender = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let monday = calender?.nextDate(after: Date(timeInterval: -60*60*24*7, since: Date()) as Date, matching: NSCalendar.Unit.weekday, value: 2, options: NSCalendar.Options.matchNextTime)
        return monday!
    }
    
    
    
    
// チャートの描画
    // 性別チャート
    func setChart() {
        chartSex.noDataText = "You need to provide data for the chart."
        chartSex.chartDescription?.text = "性別"
        
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
        chartData.barWidth = barWidth;
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        chartSex.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        chartSex.data = chartData
        //chart animation
        chartSex.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
// 年齢チャート
    func setChart2() {
        chartSex.chartDescription?.text = "年齢"
        
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
        chartData.barWidth = barWidth;
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        chartAge.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        chartAge.data = chartData
        //chart animation
        chartAge.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    
    
    
    func setChartData(){
        //性別(配列の長さ)
        for time in 0...4{
            setMale[time] = Double(unitsSet[time].filter{$0 < 10}.count)
            setFemale[time] = Double(unitsSet[time].filter{$0 >= 10}.count)
            //年齢(10の剰余で数える）
            for i in 0...5{
                setAge[time][i] = Double(unitsSet[time].filter{$0 % 10 == i}.count)
            }
        }
        
    }
    

    
    
    //datePickerへの引き継ぎ
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "godatepicker" {
            let modalVc = segue.destination as! ModalViewController2
            modalVc.textFromModal = textFromModal
            modalVc.flag = self.flag
            modalVc.minDate = firstDate
            modalVc.setsDate = dateFromModal
        }else {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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







