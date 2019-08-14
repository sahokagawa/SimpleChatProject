//
//  RoomViewController.swift
//  SimpleChatApp
//
//  Created by 香川紗穂 on 2019/08/09.
//  Copyright © 2019 香川紗穂. All rights reserved.
//

import UIKit
import Firebase

class RoomViewController: UIViewController {
    
//  つなげる
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    //どの部屋か特定するためにドキュメントIDを取得する変数を作る
    var documentId = ""
    
    //その部屋のメッセージを全件もつ配列
    //型　　Message  この間自分たちで　Message ていうクラスつくったから
    var messages: [Message] = [] {
        //変数messagesの値が変わった時に実行される
        didSet{
            //テーブルを更新する
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //おまじない
        tableView.delegate = self
        tableView.dataSource = self

    }
//  つなげる
    @IBAction func didClickButton(_ sender: UIButton) {
        //送信ボタンがクリックされた時の処理
        //空文字かどうかをテェック
        if messageTextField.text!.isEmpty {
            //処理中断
            return
        }
        
        //からじゃない！メッセージの値を送信したい
        //特定の部屋の中(ファイル・ドキュメント）で呟かれたメッセージが全件入るフォルダ（コレクション）を作る　　　ファイルの中にフォルダある
        
        //①画面に入力されたテキストを変数に保存
        //②Firebaseに接続
        //③メッセージにFirestoreに登録
        
        //①
        let message = messageTextField.text!
        
        //②
        let db = Firestore.firestore()

        
        //③     さっきdocumentIdっていう箱に渡してあげるって決めたから、その変数使う
        //roomっていう部屋 の このドキュメントIDの部屋 の　　messageって部屋の中に addDocument
        db.collection("room").document(documentId).collection("message").addDocument(data: [
            "text": message,
            "createdAt": FieldValue.serverTimestamp()
        ]) { error in
            if let err = error{
                print("メッセージの送信に失敗しました")
                print(err)
            }else{
                print("メッセージを成功しました")
            }
            
        }
        
        //メッセージ入力欄をからにする
        messageTextField.text = ""
    }
    

}

extension RoomViewController: UITableViewDelegate,UITableViewDataSource {
    
    //テーブルに表示するデータの件数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //１行めにはkこの文字を、2行めにはこの文字を！みたいな
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの取得　セルの名前と行番号から
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //取得セルにメッセージのテキストを設定
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.text
        //できたセルを画面に返却
        return cell
    }
    
    
}
