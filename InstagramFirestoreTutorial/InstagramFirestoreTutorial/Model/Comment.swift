//
//  Comment.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2022/10/18.
//

import Firebase

struct Comment {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let commentText: String
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        // 파이어베이스의 콜렉션 이름을 comment로 만들었으니, 해당 dictionary의 이름은 comment
        // 하지만 보다시피 프로퍼티의 이름은 바꿔도 된다. 다만 헷갈리지 않게 주의.
        self.commentText = dictionary["comment"] as? String ?? ""

    }
    
    
}
