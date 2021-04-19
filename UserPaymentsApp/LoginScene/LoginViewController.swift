//
//  LoginViewController.swift
//  UserPaymentsApp
//
//  Created by Дмитрий Кузнецов on 17.04.2021.
//

import UIKit

// MARK: - LoginViewController class
class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: LoginPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupScenes.setupLoginScene(with: self)
        setupShowPasswordButton()
        
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Удаление старых данных
        presenter = LoginPresenter(view: self)
        passwordTextField.text = nil
        loginTextField.text = nil
    }
    
    // Закрытие клавиатуры при тапе на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // Событие при тапе на кнопку log on
    @IBAction func postDataButton(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        presenter.postData(login: loginTextField.text,
                           password: passwordTextField.text)
    }
    
    // Показать пароль
    @objc func showPasswordButton(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        let destinationView = segue.destination as! PaymentsTableViewController
        SetupScenes.setupPaymentScene(with: destinationView, and: sender)
    }
    
    // Добавление и настройка кнопки показа пароля
    private func setupShowPasswordButton() {
        let passwordButton = UIButton(frame: CGRect(x: 0,
                                             y: 0,
                                             width: passwordTextField.frame.width * 0.20,
                                             height: passwordTextField.frame.height * 0.20))
        passwordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        passwordButton.addTarget(self, action: #selector(showPasswordButton), for: .touchUpInside)
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = passwordButton
    }
}

// MARK: - extensions LoginViewController
extension LoginViewController: LoginViewProtocol{
    func performSegue(with token: String) {
        activityIndicator.stopAnimating()
        performSegue(withIdentifier: "LoginToPayments", sender: token)
    }
    
    // Настройка алерта
    func showAlertController(with title: String, and message: String) {
        activityIndicator.stopAnimating()
        
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alertVC.addAction(OKAction)
        present(alertVC, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if  textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        }
        if  textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
