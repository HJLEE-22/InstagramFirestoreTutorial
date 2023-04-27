//
//  AuthentificationViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2022/09/15.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

protocol FormViewModel {
    func updateForm()
}

protocol AuthentificationViewModel {
    var formIsValid : Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}
 
struct LoginViewModel: AuthentificationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
 
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct AuthentificationViewModelRx: ViewModelType {
    struct Input {
        var email = PublishSubject<String>()
        var password = BehaviorSubject<String?>(value: nil)
        var fullName = BehaviorSubject<String?>(value: nil)
        var userName = BehaviorSubject<String?>(value: nil)
        var loginButtonTapped = PublishSubject<Void>()
        var resetButtonTapped = PublishSubject<Void>()
        var plusPhotoButtonTapped = PublishSubject<Void>()
        var signUpButtonTapped = PublishSubject<Void>()
    }
    
    struct Output {
        var formIsValid: Driver<Bool>
        var buttonBackgroundColor: Driver<UIColor>
        var buttonTitleColor: Driver<UIColor>
        var selectedImage: Driver<UIImage?>
    }
    
    weak var delegate: AuthenticationDelegate?
    var disposeBag = DisposeBag()
    var input = Input()
    lazy var output = transform(input: input)

    private var pickerDelegate = RxPHPickerDelegate()
    
    func transform(input: Input) -> Output {
        
        input.loginButtonTapped
            .withLatestFrom(Observable.combineLatest(input.email, input.password))
            .map({ email, password in
                guard let password else { return }
                AuthServie.logUserIn(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG : Failed to register user \(error.localizedDescription)")
                        return
                    }
                    self.delegate?.authenticationDidComplete()
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        let formIsValid = Observable.combineLatest(input.email, input.password, input.fullName, input.userName)
            .map { email, password, fullName, userName in
                guard let password else {
                    return email.isEmpty == false
                }
                guard let fullName, let userName else {
                    return email.isEmpty == false && password.isEmpty == false
                }
                return email.isEmpty == false && password.isEmpty == false
                    && fullName.isEmpty == false && userName.isEmpty == false
            }
            .asDriver(onErrorJustReturn: false)
            
        let buttonBackgroundColor = formIsValid
            .map { $0 ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)}

        let buttonTitleColor = formIsValid
            .map { $0 ? .white : UIColor(white: 1, alpha: 0.67)}
                
        let selectedImage = input.plusPhotoButtonTapped
            .flatMap { _ in
                pickerDelegate.pickerObservable
            }
            .flatMap { results -> Observable<UIImage?> in
                return Observable.create { observer in
                    let itemProvider = results.first?.itemProvider
                    if let itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                            guard error == nil else { return observer.onError(error!) }
                            let imageAsUIImage = image as? UIImage
                            observer.onNext(imageAsUIImage)
                            observer.onCompleted()
                        }
                    } else {
                        observer.onNext(nil)
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
            .asDriver(onErrorJustReturn: UIImage())
            
        input.signUpButtonTapped
            .withLatestFrom(Observable.combineLatest(input.email, input.password, input.fullName, input.userName, selectedImage.asObservable()))
            .map { email, password, fullName, userName, image in
                guard let password,
                      let fullName,
                      let userName = userName?.lowercased(),
                      let image else { return }
                let credentials = AuthCredentials(email: email, password: password, fullname: fullName, username: userName, profileImage: image)
                
                AuthServie.registerUser(withCrediential: credentials) { error in
                    if let error = error {
                        print("DEBUG : Failed to register user \(error.localizedDescription)")
                        return
                    }
                    self.delegate?.authenticationDidComplete()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
            
            /*
             extension RegistrationController : PHPickerViewControllerDelegate {
                 func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

                     // 피커뷰 dismiss
                     picker.dismiss(animated: true)
                     
                     let itemProvider = results.first?.itemProvider
                     
                     if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
             itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                 DispatchQueue.main.async {
                     // 이미지뷰에 표시
                     self.profileImage = image as? UIImage
                                 self.plusPhotoButton.layer.cornerRadius = self.plusPhotoButton.frame.width / 2
                                 self.plusPhotoButton.layer.masksToBounds = true
                                 self.plusPhotoButton.layer.borderColor = UIColor.black.cgColor
                                 self.plusPhotoButton.layer.borderWidth = 2
                                 self.plusPhotoButton.setBackgroundImage(image as? UIImage, for: .normal)
                                 self.plusPhotoButton.setImage(nil, for: .normal)
                             }
                         }
                     } else {
                         print("이미지 못 불러왔음!!!!")
                     }
                 }
             }
             
             */
        
        return Output(formIsValid: formIsValid, buttonBackgroundColor: buttonBackgroundColor, buttonTitleColor: buttonTitleColor, selectedImage: selectedImage)
    }
}


struct RegistrationViewModel: AuthentificationViewModel {
    
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
        && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor  {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct ResetPasswordViewModel: AuthentificationViewModel {
    
    var email: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor  {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
}
