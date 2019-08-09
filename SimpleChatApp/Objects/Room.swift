//
//  Room.swift
//  SimpleChatApp
//
//  Created by 香川紗穂 on 2019/08/09.
//  Copyright © 2019 香川紗穂. All rights reserved.
//


//いつもは　class Roomとかで書くけど...今回新しいので書いてみる！
//チャットの部屋の情報を持つ構造体
struct Room {
//    部屋の名前
    let name: String
    
//    部屋のID(Firestoreでシユするキーを入れる)
    let documentId: String
}
