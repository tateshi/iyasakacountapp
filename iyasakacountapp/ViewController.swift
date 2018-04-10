//
//  ViewController.swift
//  iyasakacountapp
//
//  Created by 八重尾 立志 on 2018/04/05.
//  Copyright © 2018年 Yaeo Tateshi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //戻る遷移のための設定
    @IBAction func returnToTop(segue: UIStoryboardSegue) {}

    //時間帯
    var time = 0
    //集計用の配列
    var unitsMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var unitsFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    //チャートに使用する配列
    var chartMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var chartFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var chartAge = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]

    
    //合計人数表示
    @IBOutlet weak var total: UILabel!
    
    var totalCount = 0
    func updateCounter() {
    //合計人数カウンター
        totalCount += 1
        total.text = String(totalCount)
        
    //チャート用の配列に移す
        //性別
        let plus = { (a: Double, b: Double) -> Double in a + b }
        chartMale[time] = unitsMale.reduce(0.0, plus)
        chartFemale[time] = unitsFemale.reduce(0.0, plus)
        //年齢
        for i in 0...5{
            chartAge[time][i] = unitsMale[i] + unitsFemale[i]
        }
    }

    
/*
    //時間帯の移行ボタン
    @IBAction func timeshift(_ sender: Any) {
        if time == 5{
        }else{
            time += 1
            unitsMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            unitsFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        }
    }
*/

    //リセットボタン
    @IBAction func reset(_ sender: Any) {
        time = 0
        totalCount = 0
        total.text = String(totalCount)
        chartMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        chartFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        chartAge = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]
    }
    
    //プラスボタン
    @IBAction func maleSho(_ sender: Any) {
        unitsMale[0] += 1
        updateCounter()
    }
    @IBAction func maleChu(_ sender: Any) {
        unitsMale[1] += 1
        updateCounter()
    }
    @IBAction func male16(_ sender: Any) {
        unitsMale[2] += 1
        updateCounter()
    }
    @IBAction func male25(_ sender: Any) {
        unitsMale[3] += 1
        updateCounter()
    }
    @IBAction func male40(_ sender: Any) {
        unitsMale[4] += 1
        updateCounter()
    }
    @IBAction func male60(_ sender: Any) {
        unitsMale[5] += 1
        updateCounter()
    }
    
    @IBAction func femaleSho(_ sender: Any) {
        unitsFemale[0] += 1
        updateCounter()
    }
    @IBAction func femaleChu(_ sender: Any) {
        unitsFemale[1] += 1
        updateCounter()
    }
    @IBAction func female16(_ sender: Any) {
        unitsFemale[2] += 1
        updateCounter()
    }
    @IBAction func female25(_ sender: Any) {
        unitsFemale[3] += 1
        updateCounter()
    }
    @IBAction func female40(_ sender: Any) {
        unitsFemale[4] += 1
        updateCounter()
    }
    @IBAction func female60(_ sender: Any) {
        unitsFemale[5] += 1
        updateCounter()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goSecond" {
            let graphVc = segue.destination as! SecondViewController
            graphVc.chartMale = self.chartMale
            graphVc.chartFemale = self.chartFemale
            graphVc.chartAge = self.chartAge
        }else {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
       
    }

}


