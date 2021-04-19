//
//  PaymentModels.swift
//  UserPaymentsApp
//
//  Created by Дмитрий Кузнецов on 18.04.2021.
//

import Foundation
// MARK: Модель ответа от сервера
struct UserPaymentsResponceData: Decodable {
    let success: String?
    let response: [UserPayment]?
    let error: UserError?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case response = "response"
        case error = "error"
    }
}

// MARK: Модель платежа пользователя
struct UserPayment: Decodable {
    let amount: UnknowedType?
    let createdDate: Int?
    let currency: String?
    let operationOrder: String?
    
    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case createdDate = "created"
        case currency = "currency"
        case operationOrder = "desc"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try values.decode(UnknowedType.self, forKey: .amount)
        createdDate = try values.decode(Int.self, forKey: .createdDate)
        currency = try? values.decode(String.self, forKey: .currency)
        operationOrder = try values.decode(String.self, forKey: .operationOrder)
    }
}

// MARK: Модель обработки неправильного типа в JSON
enum UnknowedType: Decodable {
    
    case string(String)
    case int(Int)
    case double(Double)
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }
        throw Error.couldNotDefineTypeOfUnknowedType
    }
    
    enum Error: Swift.Error {
        case couldNotDefineTypeOfUnknowedType
    }
    
    // Функция возврата значения типа Double
    func unknowedTypetoString() -> Double? {
        switch self {
        case .double(let value): return value
        case .string(let value): return Double(value)
        case .int(let value): return Double(value)
        }
    }
}

// Модель для создания и показа ячейки
struct ShowPaymentModel {
    let descriptionText: String
    let amount: String
    let date: String
}
