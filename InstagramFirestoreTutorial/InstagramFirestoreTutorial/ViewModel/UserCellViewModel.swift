//
//  UserCellViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2022/09/21.
//

import Foundation

struct UserCellViewMdoel {
    private let user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String {
        return user.fullname
    }
    
    var fullname: String {
        return user.fullname
    }
    
    init(user: User) {
        self.user = user
    }
    
    
}
