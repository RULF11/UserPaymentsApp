//
//  SetupScenes.swift
//  UserPaymentsApp
//
//  Created by Дмитрий Кузнецов on 17.04.2021.
//

import Foundation

class SetupScenes {
    static func setupLoginScene(with view: LoginViewController) {
        let presenter = LoginPresenter(view: view)
        view.presenter = presenter
        presenter.view = view
    }
    
    static func setupPaymentScene(with view: PaymentsTableViewController, and token: Any?) {
        guard let token = token as? String else { return }
        let presenter = PaymentsPresenter(view: view)
        view.presenter = presenter
        presenter.view = view
        presenter.token = token
    }
}
