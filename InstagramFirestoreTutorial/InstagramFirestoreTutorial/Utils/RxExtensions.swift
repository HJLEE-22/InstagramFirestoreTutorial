//
//  RxExtensions.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2023/04/26.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

//extension Reactive where Base: PHPickerViewController {
//    var rxDelegate: DelegateProxy<PHPickerViewController, PHPickerViewControllerDelegate> {
//        return phPickerDelegateProxy.proxy(for: self.base)
//    }
//    //    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//    //        <#code#>
//    //    }
//    var picker: Observable<[PHPickerResult]> {
//        return rxDelegate
//            .methodInvoked(#selector(PHPickerViewControllerDelegate.picker(_:didFinishPicking:)))
//            .map { (parameters) in
//                return parameters[1] as! [PHPickerResult]
//            }
//    }
//}

extension Reactive where Base: PHPickerViewController {
    var picker: Observable<[PHPickerResult]> {
        let delegate = RxPHPickerDelegate()
        self.base.delegate = delegate
        return delegate.pickerObservable
    }
}
