//
//  Protocols.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2023/04/25.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

protocol ViewModelBindable: AnyObject {
    associatedtype ViewModel: ViewModelType
    
    var disposeBag: DisposeBag { get set }
    var viewModelRx: ViewModel! { get set }
    
    func bindViewModel()
}

extension ViewModelBindable where Self: UIViewController {
    func bind(viewModel: ViewModel) {
        self.viewModelRx = viewModel
        bindViewModel()
    }
}

protocol CellModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

protocol CellModelBindable {
    associatedtype CellModel: CellModelType
    
    var disposeBag: DisposeBag { get set }
    var cellModel: CellModel! { get set }
    func bindCellModel()
}
