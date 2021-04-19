//
//  PaymentTableViewCell.swift
//  UserPaymentsApp
//
//  Created by Дмитрий Кузнецов on 18.04.2021.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    @IBOutlet weak var paymentDescriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Настройка содержимого ячейки
    func setupCell(model: ShowPaymentModel) {
        paymentDescriptionLabel.text = model.descriptionText
        amountLabel.text = model.amount
        dateLabel.text = model.date
    }
}
