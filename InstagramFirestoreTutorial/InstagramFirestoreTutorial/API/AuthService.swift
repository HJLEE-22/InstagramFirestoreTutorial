//
//  AuthService.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2022/09/16.
//

import Foundation
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}
// 어디서든 접근 가능하게 struct로 구현...
struct AuthServie {
    static func registerUser(withCrediential credentials: AuthCredentials) {
        print("DEBUG: Credentials are \(credentials)")
    }

}
