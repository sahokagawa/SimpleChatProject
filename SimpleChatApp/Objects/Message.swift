//
//  Message.swift
//  SimpleChatApp
//
//  Created by 香川紗穂 on 2019/08/09.
//  Copyright © 2019 香川紗穂. All rights reserved.
//


struct Message {
//    メッセージのID (Firestoreで使用するキーを入れる)
    let documentId: String
    
//    送信されたメッセージ
    let text: String
}
