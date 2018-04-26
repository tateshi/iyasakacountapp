//
//  ViewController.swift
//  iyasakacountapp
//
//  Created by 八重尾 立志 on 2018/04/05.
//  Copyright © 2018年 Yaeo Tateshi. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    
//変数の定義
    //v2.0 UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    //v2.0 保存用の日付フォーマット
    var dateLabel = ""
    //時間帯（0:15-17 1:17-19 2:19-21 3:21-23 4:23-25）
    var time = 0
    //集計用の配列
    var unitsSet:[[Int]] = [[], [], [], [], []]
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
    
    // v1.2 合計・時間帯計切り替え
    @IBAction func counterSwitch(_ sender: Any) {
        if totalLabel.text == "合計"{
            // 時間帯ごとの人数表示
            updateTime()
            totalLabel.text = String(time * 2 + 15) + "-" + String(time * 2 + 17) + "時"
            total.text = String(unitsSet[time].count)

        }else{
            // 合計人数
            totalLabel.text = "合計"
            countTotal()
        }
    }
    
    // v1.2 合計表示ラベル
    @IBOutlet weak var totalLabel: UILabel!
    
    //合計人数表示
    @IBOutlet weak var total: UILabel!

//リセットボタン
    @IBOutlet weak var backButton: UIButton!
    //ロングプレスでリセット
    @IBAction func pressLabel(_ sender: UILongPressGestureRecognizer) {
        //長押し開始
        if(sender.state == UIGestureRecognizerState.began){
            backButtonUI(str: "reset")
        //長押し終了
        } else if (sender.state == UIGestureRecognizerState.ended) {
            //アラートコントローラーを表示する。
            self.present(alert, animated: true, completion:nil)
        }
    }
    //v2.0 シングルタップで戻る処理
    @IBAction func tapLabel(_ sender: Any) {
        if unitsSet[time].count > 0{
            unitsSet[time].removeLast()
            shortVibrate()
            updateCounter()
        }
    }


    //プラスボタン
    @IBAction func maleSho(_ sender: Any) {
        plusTapped(int:0)
    }
    @IBAction func maleChu(_ sender: Any) {
        plusTapped(int: 1)
    }
    @IBAction func male16(_ sender: Any) {
        plusTapped(int: 2)
    }
    @IBAction func male25(_ sender: Any) {
        plusTapped(int: 3)
    }
    @IBAction func male40(_ sender: Any) {
        plusTapped(int: 4)
    }
    @IBAction func male60(_ sender: Any) {
        plusTapped(int: 5)
    }
    
    @IBAction func femaleSho(_ sender: Any) {
        plusTapped(int: 10)
    }
    @IBAction func femaleChu(_ sender: Any) {
        plusTapped(int: 11)
    }
    @IBAction func female16(_ sender: Any) {
        plusTapped(int: 12)
    }
    @IBAction func female25(_ sender: Any) {
        plusTapped(int: 13)
    }
    @IBAction func female40(_ sender: Any) {
        plusTapped(int: 14)
    }
    @IBAction func female60(_ sender: Any) {
        plusTapped(int: 15)
    }
    

//function
    
    //v2.0 プラスボタンの一括処理
    func plusTapped(int:Int){
        shortVibrate()
        updateTime()
        unitsSet[time].append(int)
        updateCounter()
    }

    //カウンターの更新
    func updateCounter() {
        //合計人数カウンター
        countTotal()
        //チャート用の配列に移す
        setChart()
        // v2.0 データの保存
        userDefaults.set(unitsSet, forKey: dateLabel + "unitsSet")
    }
    
    //v2.0 合計人数の計算（戻るに対応）
    func countTotal(){
        var n = 0
        for time in 0...4{
            n += unitsSet[time].count
        }
        total.text = String(n)
    }
    
    func setChart(){
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
    
    
    //日付取得
    func getNowDate(){
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()
        //昨日
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        
        let nowTime = Int(getNowTime())
        //v2.0 5時台までは前日の日付を使用
        if nowTime! <= 5 {
            //ヘッダー表示用
            dateFormatter.dateFormat = "M月dd日 EEE曜日"
            date.text = dateFormatter.string(from: yesterday!)
            //v2.0 保存ラベル用
            dateFormatter.dateFormat = "yyyyMMdd"
            dateLabel = dateFormatter.string(from: yesterday!)
        }else{
            dateFormatter.dateFormat = "M月dd日 EEE曜日"
            date.text = dateFormatter.string(from: today)
            dateFormatter.dateFormat = "yyyyMMdd"
            dateLabel = dateFormatter.string(from: today)
        }
    }

    //v1.1 時間取得
    func getNowTime()-> String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ja_JP")
        timeFormatter.dateFormat = "HH"
        return timeFormatter.string(from: Date())
    }
    
    //v1.1 時間帯の自動更新
    func updateTime() {
        // 現在時刻を取得
        let nowTime = Int(getNowTime())
        if nowTime! <= 5 {
            time = 4
        }else{
            time = 0
            while nowTime! >= time * 2 + 17{
                time += 1
            }
        }
    }

    // (v2.1 修正) 一日のリセット処理
    @objc func autoReset() {
        // 日時を取得
        getNowDate()
        // 当日データがある場合、データをロード
        if  UserDefaults.standard.object(forKey: dateLabel + "unitsSet") != nil {
            unitsSet = userDefaults.object(forKey: dateLabel + "unitsSet") as! [[Int]]
            updateCounter()
        }else{
        // ない場合、リセット
            reset()
        }
    }

   
    //一日のリセット
    func reset(){
        unitsSet = [[], [], [], [], []]
        updateCounter()
    }
    
    //v1.2 タップ音（バイブレーション）
    func shortVibrate() {
        AudioServicesPlaySystemSound(1003);
        AudioServicesDisposeSystemSoundID(1003);
    }
    
    //v2.0 戻るボタンのUI
    func backButtonUI(str:String) {
        if str == "back"{
            backButton.setTitle("戻す", for: .normal)
            backButton.setTitleColor(UIColor.black, for: .normal)
        }else if str == "reset"{
            backButton.setTitle("リセット", for: .normal)
            backButton.setTitleColor(UIColor.red, for: .normal)
            
        }
    }
    


    
// 起動時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //日付取得
        getNowDate()
    
    //var2.1 データの更新処理
        let notificationCenter = NotificationCenter.default
        //アプリがアクティブになったとき、autoReset()を呼び出す
        notificationCenter.addObserver(
            self,
            selector: #selector(type(of: self).autoReset),
            name: .UIApplicationDidBecomeActive,
            object: nil)
        
    //v2.0 常時アクティブの際、3600秒ごとにautoReset()を呼び出す
        _ = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(self.autoReset), userInfo: nil, repeats: true)
        

    //v1.1 リセットボタン
        //v1.1 アラートコントローラーを作成する。
        alert = UIAlertController(title: "確認", message: "当日分のデータが消去されます。", preferredStyle: UIAlertControllerStyle.alert)
        //「続けるボタン」のアラートアクションを作成する。
        let alertAction = UIAlertAction(
            title: "リセット",
            style: UIAlertActionStyle.default,
            handler: { action in
                //リセット処理
                self.reset()
                self.backButtonUI(str:"back")
        })
        //「キャンセルボタン」のアラートアクションを作成する。
        let alertAction2 = UIAlertAction(
            title: "キャンセル",
            style: UIAlertActionStyle.cancel,
            handler: { action in
                self.backButtonUI(str:"back")
        }
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




