//
//  ModalViewController.swift
//  iyasakacountapp
//
//  Created by 佐久間竜 on 2018/04/26.
//  Copyright © 2018年 Yaeo Tateshi. All rights reserved.
//

import UIKit

// モーダルビュー2
class ModalViewController2: UIViewController {
    //secondからの引き継ぎ
    var flag = 0
    var minDate = Date()
    var setsDate = Date()
    var textFromModal = ""

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // 最初に表示する日付
        datePicker.setDate(setsDate, animated: false)
        // メッセージの設定
        if textFromModal == "月間"{
            message.text = "集計する月を指定"
        }else if textFromModal == "指定"{
            if flag == 1{
                message.text = "終了日を指定"
                // datePickerの最小値
                datePicker.minimumDate = minDate
                flag = 0
            }else{
                message.text = "開始日を指定"
                flag = 1
            }
        }
        // datePickerの最大値
        datePicker.maximumDate = Date()
        // 背景をグレーで透過する
        datePicker.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        // 押された時の処理を設定
        dismissButton.addTarget(self, action: #selector(pushDismiss(sender:)), for: .touchUpInside)
    }
    
    // dismissボタンが押された時の処理
    @objc func pushDismiss(sender:UIButton) {
        // これ自体はUIViewController型なので、HomeViewController型に強制ダウンキャストする
        let originVc = presentingViewController as! SecondViewController
        // datePickerの日付をHomeViewController側に設定
        originVc.flag = flag
        originVc.dateFromModal = datePicker.date
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
