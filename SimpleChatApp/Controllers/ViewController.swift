//
//  ViewController.swift
//  SimpleChatApp
//
//  Created by 香川紗穂 on 2019/08/08.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

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
        
        //おまじない
        tableView.delegate = self
        tableView.dataSource = self
        
        //変更されたかどうかを検知するリスナー　　複数人でデータを変更する可能性ある　　roomをずーと監視してくれる
        //Firestoreへ接続
        let db = Firestore.firestore()
        //コレクションroomが変更されたか検知するリスナーを登録
        db.collection("room").addSnapshotListener { (querySnapshot, error) in
        //print("変更されました")
            
            //querySnapshot?.documents ：room内の全件を取得　それをdocumentsに入れる
            guard let documents = querySnapshot?.documents else{
                //roomの中に何もない場合、処理を中断
                return
            }
            
            //変数documentsにroomに全データがあるとき、それを元に配列を作成し、画面を更新する
            //querySnapshot?.documentsじゃ配列は作れないから新しい変数作る
            var results: [Room] = []
            
            //for文で回して配列に入れてく
            for document in documents{
                //documentの中には、名前と日付入ってる
                let roomName = document.get("name") as! String
                let room = Room(name: roomName, documentId: document.documentID)   //インスタンス化
                //作ったroomをresultsに入れる
                results.append(room)
            }
            //変数roomsを書き換える
            self.rooms = results
        }
    }
    
    

    //ボタンをつなげる　　左のbuttonの方からつなげること！
    // ボタンがクリックされたら、トークルームが追加されるようにしたい！
    @IBAction func didClickButton(_ sender: UIButton) {
        //空文字のトークルームなんてないよね
        if roomNameTextField.text!.isEmpty{
            //処理中断
            return
        }
        
        //以下、入力された場合
        //部屋の名前を変数に保存   本当はオプショナルバインディングとか使った方がいいけど、今回は！で無理やり剥がす
        let roomName = roomNameTextField.text!
        
        //Firestoreにの接続情報を取得　　決まり文句
        let db = Firestore.firestore()
        //FIrestoreに新しい部屋を追加　　　新しくroomっていうこコレクション作ってくださいねー！
        //MYSQLのcreate tableとかと違って、勝手に追加してくれる　（？？？ここよくわからん？）
        
        //ディクショナリーで値（登録データ）を渡す　    キー　name createAt
        db.collection("room").addDocument(data: ["name":roomName,
                                                 "createAt":FieldValue.serverTimestamp()
        ]) { err in
            
            if let err = err{
                print("チャットルームの作成に失敗しました")
                print(err)
            }else{
                print("チャットルームを作成しました：\(roomName)")
            }
        }
        roomNameTextField.text = ""
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
        
        //右矢印設定  セルの右側に出てくるやつや！
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
   //セルがクリックされたら 次の画面に遷移するようにする
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //roomsって配列の中にいろんな情報入ってる
        //どこのセルかはindexPath
        //じゃあ、選択された一つの部屋の情報を渡しますよー！
        let room = rooms[indexPath.row]
        
        //次の画面に行って前の画面に戻ってきた時に選択されてグレーになってるっていう状態を解除
        //固定文！
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        performSegue(withIdentifier: "toRoom", sender: room.documentId)
    }
    
    
    //その情報は次の画面のこの箱に渡すよー！
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoom" {
            
            let roomVC = segue.destination as! RoomViewController
            roomVC.documentId = sender as! String
            
        }
    }
}
