//
//  PaymentsTableViewController.swift
//  UserPaymentsApp
//
//  Created by Дмитрий Кузнецов on 17.04.2021.
//

import UIKit

// MARK: - LoginViewController class
class PaymentsTableViewController: UITableViewController {
    
    var presenter: PaymentsPresenter!
    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogOutButton()
        addActivityIndicator()
        
        DispatchQueue.global().async {
            self.presenter.getPaymentsdata()
        }
    }
    
    // Настройка положения activityIndicator
    override func viewWillLayoutSubviews() {
        let x = tableView.bounds.midX
        let y = tableView.bounds.midY
        activityIndicator.frame = CGRect(x: x, y: y, width: 0, height: 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.paymentsModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PaymentTableViewCell
        let payment = presenter.paymentsModel[indexPath.row]
        cell.setupCell(model: payment)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = presenter.paymentsModel[indexPath.row]
        showDetailInfo(with: model)
        navigationController?.popToRootViewController(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    
    // Возврат на предыдущий экран при нажатии на Log out
    @objc func logOutAction() {
        showAlertController(with: "Log out?", and: "", cancelButton: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Настройка показа деталей платежа
    private func showDetailInfo(with showModel: ShowPaymentModel) {
        let title = "Детали платежа"
        let message = """
                        Описание: \(showModel.descriptionText)
                        Сумма: \(showModel.amount)
                        Дата: \(showModel.date)
                      """
        
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .actionSheet)
        
        let OKAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alertVC.addAction(OKAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    private func setupLogOutButton() {
        navigationItem.hidesBackButton = true
        
        let newBackButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOutAction))
        navigationItem.leftBarButtonItem = newBackButton
    }
    
    // Настройка activityIndicator
    private func addActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        tableView.addSubview(activityIndicator)
    }
}

// MARK: - extension LoginViewController
extension PaymentsTableViewController: PaymentsViewProtocol {
    // Перезагрузка ячеек
    func reloadTableData() {
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    // Настройка алерта
    func showAlertController(with title: String,
                             and message: String,
                             cancelButton: Bool,
                             complition:  (() -> Void)?) {
        
        activityIndicator.stopAnimating()
        
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK",
                                     style: .default) { (_) in
            complition?()
        }
        
        if cancelButton {
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel,
                                             handler: nil)
            alertVC.addAction(cancelAction)
        }
        
        alertVC.addAction(OKAction)
        present(alertVC, animated: true, completion: nil)
    }
}
