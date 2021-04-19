//
//  PaymentsPresenter.swift
//  UserPaymentsApp
//
//  Created by Дмитрий Кузнецов on 17.04.2021.
//

import Foundation

// MARK: - Протоколы
protocol PaymentsPresenterProtocol: class {
    var token: String! { get set }
    var paymentsModel: [ShowPaymentModel] { get }
    init(view: PaymentsViewProtocol)
    func getPaymentsdata()
}

protocol PaymentsViewProtocol: class {
    func reloadTableData()
    func showAlertController(with title: String,
                             and message: String,
                             cancelButton: Bool,
                             complition:  (() -> Void)?)
}

// MARK: - PaymentsPresenter class
class PaymentsPresenter: PaymentsPresenterProtocol {
    
    unowned var view: PaymentsViewProtocol!
    var paymentsModel: [ShowPaymentModel] = []
    var token: String!
    
    required init(view: PaymentsViewProtocol) {
        self.view = view
    }
    
    // Запрос на получение данных о платежах пользователя
    func getPaymentsdata() {
        NetworkManager.shared.getPaymentsData(url: URLList.getPaymentsData.rawValue,
                                              token: token) { (userPaymentsGetDataDemo) in
            self.checkData(data: userPaymentsGetDataDemo)
        }
    }
    
    // Проверка ответа с сервера на наличие ошибок и наличия данных
    private func checkData(data: UserPaymentsResponceData) {
        if let error = data.error {
            guard
                let errorCode = error.errorCode,
                let errorMsg = error.errorMsg
            else { return }
            DispatchQueue.main.async {
                self.view.showAlertController(with: "Error code: \(errorCode)",
                                              and: errorMsg,
                                              cancelButton: false,
                                              complition: nil)
            }
        }
        guard let response = data.response else { return }
        setupDataToShow(payments: response)
    }
    
    // Подготовка данных к показу
    private func setupDataToShow(payments: [UserPayment]) {
        payments.forEach { (payment) in
            let descriptionText = payment.operationOrder ?? "No info about operation"
            
            let amount = payment.amount?.unknowedTypetoString() ?? 0
            let amountText = "\(round(amount*100)/100) \(payment.currency ?? "RUR")"
            
            let date = Date(timeIntervalSince1970: TimeInterval(payment.createdDate ?? -1))
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            let dateTimeText = dateFormatter.string(from: date)
            
            let model = ShowPaymentModel(descriptionText: descriptionText,
                                         amount: amountText,
                                         date: dateTimeText)
            paymentsModel.append(model)
        }
        DispatchQueue.main.async {
            self.view.reloadTableData()
        }
    }
}




