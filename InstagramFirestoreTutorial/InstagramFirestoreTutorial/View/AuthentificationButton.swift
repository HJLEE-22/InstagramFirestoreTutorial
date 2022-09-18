//
//  AuthentificationButton.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2022/09/15.
//

import UIKit

class AuthentificationButton: UIButton {
    
    init(title: String, type: UIButton.ButtonType = .system) {
        super.init(frame: .zero)

        
        setTitle(title, for: .normal)
        setTitleColor(.white.withAlphaComponent(0.67), for: .normal)
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)

        layer.cornerRadius = 5
        setHeight(50)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    
}
