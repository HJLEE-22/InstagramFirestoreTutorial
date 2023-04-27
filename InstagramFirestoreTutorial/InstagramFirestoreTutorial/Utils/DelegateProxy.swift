//
//  DelegateProxy.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2023/04/26.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

//final class phPickerDelegateProxy: DelegateProxy<PHPickerViewController, PHPickerViewControllerDelegate>, DelegateProxyType, PHPickerViewControllerDelegate {
//    static func registerKnownImplementations() {
//        self.register { (phPicker) -> phPickerDelegateProxy in
//            phPickerDelegateProxy(parentObject: phPicker, delegateProxy: self)
//        }
//    }
//
//    static func currentDelegate(for object: PHPickerViewController) -> PHPickerViewControllerDelegate? {
//        return object.delegate
//    }
//
//    static func setCurrentDelegate(_ delegate: PHPickerViewControllerDelegate?, to object: PHPickerViewController) {
//        object.delegate = delegate
//    }
//
////    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
////        <#code#>
////    }
//}

final class RxPHPickerDelegate: NSObject, PHPickerViewControllerDelegate {
    private let pickerSubject = PublishSubject<[PHPickerResult]>()

    var pickerObservable: Observable<[PHPickerResult]> {
        return pickerSubject.asObservable()
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        pickerSubject.onNext(results)
    }
}
