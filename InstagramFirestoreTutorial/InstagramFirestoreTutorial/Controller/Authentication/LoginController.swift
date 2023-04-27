//
//  LoginController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2022/09/15.
//

import UIKit
import RxSwift
import RxCocoa

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete()
}


class LoginController: UIViewController {
    
    // MARK: - Rx Properties
    
    private var viewModel = LoginViewModel()
    var viewModelRx: AuthentificationViewModelRx!
    
    var disposeBag = DisposeBag()
    weak var delegate: AuthenticationDelegate?
    
    // MARK: - UI Properties
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.67), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account? ", secondPart: "Sign Up")
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        bindWithoutViewModel()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
}

extension LoginController: ViewModelBindable {
    
    func bindWithoutViewModel() {
        dontHaveAccountButton.rx.tap
            .withUnretained(self)
            .subscribe { selfController, event in
                let controller = RegistrationController()
                controller.delegate = selfController.delegate
                let viewModel = AuthentificationViewModelRx()
                controller.bind(viewModel: viewModel)
                selfController.navigationController?.pushViewController(controller, animated: true)
            }
            .disposed(by: disposeBag)
        
        forgotPasswordButton.rx.tap
            .withUnretained(self)
            .subscribe { selfController, event in
                let controller = ResetPasswordController()
                let viewModel = AuthentificationViewModelRx()
                controller.bind(viewModel: viewModel)
                selfController.navigationController?.pushViewController(controller, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        loginButton.rx.tap
            .bind(to: viewModelRx.input.loginButtonTapped)
            .disposed(by: disposeBag)
        
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
        
        viewModelRx.output.formIsValid
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModelRx.output.buttonTitleColor
            .drive(onNext: { [weak self] color in
                guard var title = self?.loginButton.titleLabel else { return }
                title.textColor = color
            })
        // 강제 옵셔널 해제를 피하기 위해 사용
        // .drive(loginButton.titleLabel!.rx.textColor)
            .disposed(by: disposeBag)
                   
        viewModelRx.output.buttonBackgroundColor
            .drive(loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
            
        
    }
}
