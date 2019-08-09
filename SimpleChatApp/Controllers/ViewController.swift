//
//  ViewController.swift
//  SimpleChatApp
//
//  Created by 香川紗穂 on 2019/08/08.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    テキストフィールドとテーブルビューをつなげる
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
//    チャットの部屋一覧を保持する配列
    var rooms: [Room] = [] {
        //roomsが書き換わったとき
        didSet {
        //テーブルを更新する
            tableView.reloadData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //おまじない
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    

    //ボタンをつなげる　　左のbuttonの方からつなげること！
    @IBAction func didClickButton(_ sender: UIButton) {
    }
    
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //何件表示するか
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //一件表示する部屋を取ってくる
        let room = rooms[indexPath.row]
        cell.textLabel?.text = room.name
        //structの中のroomの名前欲しい
        
        //右矢印設定
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
}
