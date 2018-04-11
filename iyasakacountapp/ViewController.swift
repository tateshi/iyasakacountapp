//
//  ViewController.swift
//  iyasakacountapp
//
//  Created by 八重尾 立志 on 2018/04/05.
//  Copyright © 2018年 Yaeo Tateshi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//変数の定義
    //時間帯（0:15-17 1:17-19 2:19-21 3:21-23 4:23-25）
    var time = 0
    //合計人数
    var totalCount = 0
    
    //集計用の配列
    var unitsMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var unitsFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    //チャート用の配列
    //性別
    var setMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var setFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    //年齢構成
    var setAge = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]
    
    //v1.1 アラート
    var alert:UIAlertController!


//IB
    //戻る遷移のための設定
    @IBAction func returnToTop(segue: UIStoryboardSegue) {}

    //日付表示
    @IBOutlet weak var date: UILabel!
    
    //合計人数表示
    @IBOutlet weak var total: UILabel!

    //時間帯表示
    @IBOutlet weak var timezone: UILabel!

    //リセットボタン
    @IBOutlet weak var button: UIButton!
    @IBAction func reset(_ sender: Any) {
        //アラートコントローラーを表示する。
        self.present(alert, animated: true, completion:nil)
 
/*　ver 1.0 時間遷移ボタン
        let tappedButton:UIButton = sender as! UIButton
        if time == 3{
            //23-25のときボタンのUIをリセットに変更
            tappedButton.setTitle("リセット", for: .normal)
            tappedButton.setTitleColor(UIColor.red, for: .normal)
        }
        
        if time == 4{
            //リセット処理
            time = 0
            totalCount = 0
            total.text = String(totalCount)
            setMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            setFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            setAge = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]
            timezone.text = "15-17"
            tappedButton.setTitle("時間変更", for: .normal)
            tappedButton.setTitleColor(UIColor.black, for: .normal)
        
        }else{

            //時間帯の変更処理
            time += 1
            unitsMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            unitsFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            timezone.text = String(time * 2 + 15) + "-" + String(time * 2 + 17)

        }
*/
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
    

//function
    //プラスボタン後の更新
    func updateCounter() {
        //合計人数カウンター
        totalCount += 1
        total.text = String(totalCount)
        
        //チャート用の配列に移す
        //性別
        let plus = { (a: Double, b: Double) -> Double in a + b }
        setMale[time] = unitsMale.reduce(0.0, plus)
        setFemale[time] = unitsFemale.reduce(0.0, plus)
        //年齢
        for i in 0...5{
            setAge[time][i] = unitsMale[i] + unitsFemale[i]
        }
    }
    
    //v1.1 時間取得
    func getNowTime()-> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        return timeFormatter.string(from: Date())
    }
   
    //v1.1 時間帯の自動遷移
    @objc func update() {
        // 現在時刻を取得
        let nowTime = Int(getNowTime())
        if nowTime! >= time * 2 + 17{
            time += 1
            unitsMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            unitsFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            timezone.text = String(time * 2 + 15) + "-" + String(time * 2 + 17)
        }else{
        }
 
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
    //日付表示
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月dd日 EEE曜日"
        date.text = dateFormatter.string(from: Date())
        
        
    //v1.1 60秒ごとにupdate()を呼び出す
        _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)

    //v1.1 リセットボタン表示
        button.setTitle("リセット", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        
    //v1.1 アラートコントローラーを作成する。
        alert = UIAlertController(title: "確認", message: "全てのデータが消去されます。", preferredStyle: UIAlertControllerStyle.alert)
        
        //「続けるボタン」のアラートアクションを作成する。
        let alertAction = UIAlertAction(
            title: "リセット",
            style: UIAlertActionStyle.default,
            handler: { action in
                //リセット処理
                self.time = 0
                self.totalCount = 0
                self.total.text = String(self.totalCount)
                self.unitsMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                self.unitsFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                self.setMale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                self.setFemale = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                self.setAge = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]
                self.timezone.text = "15-17"

        })
        
        
        //「キャンセルボタン」のアラートアクションを作成する。
        let alertAction2 = UIAlertAction(
            title: "キャンセル",
            style: UIAlertActionStyle.cancel,
            handler: nil
        )
        //アラートアクションを追加する。
        alert.addAction(alertAction)
        alert.addAction(alertAction2)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //secondへの引き継ぎ
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goSecond" {
            let secondVc = segue.destination as! SecondViewController
            secondVc.setMale = self.setMale
            secondVc.setFemale = self.setFemale
            secondVc.setAge = self.setAge
        }else {
        }
    }

}




