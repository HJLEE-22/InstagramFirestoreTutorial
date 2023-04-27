//
//  AuthService.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2022/09/16.
//

import UIKit
import Firebase


struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthServie {
    
    static func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCrediential credentials: AuthCredentials, completion: @escaping(Error?)->Void) {
        ImageUploader.uploadImage(image: credentials.profileImage) { imageURL in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("DEBUG : Failed to register user \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                let data: [String:Any] = ["email": credentials.email,
                                          "fullname": credentials.fullname,
                                          "profileImageUrl": imageURL,
                                          "uid": uid,
                                          "username": credentials.username]
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    // firebase library를 이용한 password reset
//    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?) {
//        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
//    }
}
