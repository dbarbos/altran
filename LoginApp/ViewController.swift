//
//  ViewController.swift
//  LoginApp
//
//  Created by Diler Barbosa on 02/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.becomeFirstResponder()
        
        emailTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.emailTextPublishSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.passwordTextPublishSubject).disposed(by: disposeBag)
        
        loginViewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: loginButton.rx.alpha).disposed(by: disposeBag)
        
        
    }
    
    
    @IBAction func onLoginButtonTap(_ sender: UIButton) {
        print("Pronto para logar!")
    }
    

}

class LoginViewModel {
    let emailTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(emailTextPublishSubject.asObservable().startWith(""), passwordTextPublishSubject.asObservable().startWith("")).map { email, password in
            return email.count > 3 && password.count > 3
        }.startWith(false)
    }
}

