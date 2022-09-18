//
//  ChatUser.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/16.
//

import AppwriteModels
import Foundation

class ChatUser: Identifiable {
    public let id: String
    public let name: String
    public let fullname: String
    public let image_path: String
    public let email: String
    public let public_key: String
    public var chat_ids: [String]

    init(id: String, name: String, fullname: String, image_path: String, email: String, public_key: String, chat_ids:[String]) {
        self.id = id
        self.name = name
        self.fullname = fullname
        self.image_path = image_path
        self.email = email
        self.public_key = public_key
        self.chat_ids = chat_ids
    }

    public static func from(map: [String: Any]) -> ChatUser {
        return ChatUser(
            id: map["id"] as! String,
            name: map["name"] as! String,
            fullname: map["fullname"] as! String,
            image_path: map["image_path"] as? String ?? "" ,
            email: map["email"] as? String ?? "",
            public_key: map["public_key"] as? String ?? "",
            chat_ids: map["chat_ids"] as? [String] ?? []
        )
    }
    
    public func toMap() -> [String: Any] {
            return [
                "id": id as Any,
                "name": name as Any,
                "fullname": fullname as Any,
                "image_path": image_path as Any,
                "email": email as Any,
                "public_key": public_key as Any,
                "chat_ids": chat_ids as Any
            ]
        }
}
