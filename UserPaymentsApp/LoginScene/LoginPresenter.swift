//
//  LoginPresenter.swift
//  UserPaymentsApp
//
//  Created by Дмитрий Кузнецов on 17.04.2021.
//

import Foundation

// MARK: - Протоколы
protocol LoginPresenterProtocol: class {
    init(view: LoginViewProtocol)
    func postData(login: String?, password: String?)
}

protocol LoginViewProtocol: class {
    func showAlertController(with title: String, and message: String)
    func performSegue(with token: String)
}

// MARK: - LoginPresenter class
class LoginPresenter: LoginPresenterProtocol {
    
    unowned var view: LoginViewProtocol
    private var data: UserResponceData! {
        didSet{
            checkData()
        }
    }
    
    required init(view: LoginViewProtocol) {
        self.view = view
    }
 
    // Проверка и отправка данных на сервер
    func postData(login: String?, password: String?) {
        guard let login = login, login.count>0,
              let password = password, password.count>0
        else {
            DispatchQueue.main.async {
                self.view.showAlertController(with: "Login or password is empty",
                                              and: "Enter login and password, please!")
            }
            return
        }
        
        NetworkManager.shared.postData(url: URLList.postLoginData.rawValue,
                                       login: login.lowercased(),
                                       password: password) { (userResponceData) in
            self.data = userResponceData
        }
    }
    
    // Проверка ответа с сервера на наличие ошибок и наличия токена
    private func checkData() {
        if let error = data.error {
            guard
                let errorCode = error.errorCode,
                let errorMsg = error.errorMsg
            else { return }
            DispatchQueue.main.async {
                self.view.showAlertController(with: "Error code: \(errorCode)",
                                              and: errorMsg)
            }
        }
        guard let token = data.userData?.token else { return }
        DispatchQueue.main.async {
            self.view.performSegue(with: token)
        }
    }
}
