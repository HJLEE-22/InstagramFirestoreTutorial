//
//  RegistrationController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2022/09/15.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    var viewModelRx: AuthentificationViewModelRx!
    var disposeBag = DisposeBag()
    
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "plus_photo"), for: .normal)
        button.setImage(nil, for: .normal)
        button.tintColor = .white
//        button.addTarget(self, action: #selector(imagePickerTapped), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextField = CustomTextField(placeholder: "Fullname")
    
    private let usernameTextField = CustomTextField(placeholder: "Username")
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.67), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
//        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()

    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account? ", secondPart: "Log In")
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindWithoutViewModel()
        bindViewModel()
    }
    
    // MARK: - Actions
    
    /*

    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = profileImage else { return }

        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)

        AuthServie.registerUser(withCrediential: credentials) { error in
            if let error = error {
                print("DEBUG : Failed to register user \(error.localizedDescription)")
                return
            }
            self.delegate?.authenticationDidComplete()
        }
    }
    @objc func imagePickerTapped() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        
        // 기본설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        // 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        
        // 피커뷰 띄우기
        self.present(picker, animated: true, completion: nil)
        
    }
     */
    
    // MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.setDimensions(height: 140, width: 140)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullnameTextField, usernameTextField, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }

    
}

// MARK: - PHPicker extention
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

extension RegistrationController: ViewModelBindable {
    
    func bindWithoutViewModel() {
        alreadyHaveAccountButton.rx.tap
            .withUnretained(self)
            .subscribe { selfController, event in
                selfController.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModelRx.input.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModelRx.input.password)
            .disposed(by: disposeBag)
        
        fullnameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModelRx.input.fullName)
            .disposed(by: disposeBag)
        
        usernameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModelRx.input.userName)
            .disposed(by: disposeBag)
        
        viewModelRx.output.buttonBackgroundColor
            .drive(loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModelRx.output.buttonTitleColor
            .drive { [weak self] color in
                guard let title = self?.loginButton.titleLabel else { return }
                title.textColor = color
            }
            .disposed(by: disposeBag)
        
        viewModelRx.output.formIsValid
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        plusPhotoButton.rx.tap
            .bind(to: viewModelRx.input.plusPhotoButtonTapped)
            .disposed(by: disposeBag)
        
        plusPhotoButton.rx.tap
            .do { [weak self] event in
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 1
                let phPicker = PHPickerViewController(configuration: configuration)
                self?.present(phPicker, animated: true)
            }
            .bind(to: viewModelRx.input.plusPhotoButtonTapped)
            .disposed(by: disposeBag)
        
        viewModelRx.output.selectedImage
            .do { [weak self] _ in
                guard let self else { return }
                self.plusPhotoButton.layer.cornerRadius = self.plusPhotoButton.frame.width / 2
                self.plusPhotoButton.layer.masksToBounds = true
                self.plusPhotoButton.layer.borderColor = UIColor.black.cgColor
                self.plusPhotoButton.layer.borderWidth = 2
            }
            .drive(plusPhotoButton.rx.backgroundImage())
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModelRx.input.signUpButtonTapped)
            .disposed(by: disposeBag)
    }
    
}
