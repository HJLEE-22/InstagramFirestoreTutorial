//
//  FeedController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2022/09/14.
//

import UIKit

class FeedController: UICollectionViewController {
    
    private let reuseIdentifier = "cell"
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
}


// MARK: - CollectionViewDataSource
// 콜렉션뷰 컨트롤러이기 때문에 따로 데이타소스 프로토콜을 채택할 만들 필요는 없음

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
}

// MARK: - CollectionViewDelegateFlowLayout
// 콜렉션뷰 사이즈조정

extension FeedController: UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
}
