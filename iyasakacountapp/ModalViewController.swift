//
//  ModalViewController.swift
//  iyasakacountapp
//
//  Created by 佐久間竜 on 2018/04/26.
//  Copyright © 2018年 Yaeo Tateshi. All rights reserved.
//

import UIKit

// モーダルビュー
class ModalViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var dismissButton: UIButton!

    var choise = "日計"
    let dataList = ["日計","週間","月間","指定"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return dataList[row]
    }
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        choise = dataList[row]
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Delegate設定
        pickerView.delegate = self
        pickerView.dataSource = self
        // 押された時の処理
        dismissButton.addTarget(self, action: #selector(pushDismiss(sender:)), for: .touchUpInside)

    }
    
    // dismissボタンが押された時の処理
    @objc func pushDismiss(sender:UIButton) {
        // これ自体はUIViewController型なので、HomeViewController型に強制ダウンキャストする
        let originVc = presentingViewController as! SecondViewController
        // テキストフィールドの内容をHomeViewController側に設定
        originVc.textFromModal = choise
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
