//
//  ResetPasswordController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이형주 on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class ResetPasswordController: UIViewController {
    
    // MARK: - Properties
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private var viewModel = ResetPasswordViewModel()
    var viewModelRx: AuthentificationViewModelRx!
    var disposeBag = DisposeBag()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.67), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        configureUI()
        bindWithoutViewModel()
        bindViewModel()
    }

    // MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
                
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
}


extension ResetPasswordController: ViewModelBindable {

    func bindWithoutViewModel() {
        backButton.rx.tap
            .withUnretained(self)
            .subscribe { selfController, event in
                selfController.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        resetPasswordButton.rx.tap
            .bind(to: viewModelRx.input.resetButtonTapped)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModelRx.input.email)
            .disposed(by: disposeBag)
        
        viewModelRx.output.buttonBackgroundColor
            .drive(resetPasswordButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModelRx.output.formIsValid
            .drive(resetPasswordButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModelRx.output.buttonTitleColor
            .drive { [weak self] color in
                guard var title = self?.resetPasswordButton.titleLabel else { return }
                title.textColor = color
            }
            .disposed(by: disposeBag)
    }

}
