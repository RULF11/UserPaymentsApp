//
//  LoginModels.swift
//  UserPaymentsApp
//
//  Created by Дмитрий Кузнецов on 18.04.2021.
//

import Foundation

// MARK: Список используемых URL
enum URLList: String {
    case postLoginData = "http://82.202.204.94/api-test/login"
    case getPaymentsData = "http://82.202.204.94/api-test/payments"
}

// MARK: Модель данных для POST запроса
struct UserLoginPostData: Encodable {
    let login: String?
    let password: String?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case password = "password"
    }
}

// MARK: Модель данных ответа с сервера
struct UserResponceData: Decodable {
    let success: String?
    let userData: UserPersonalData?
    let error: UserError?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case userData = "response"
        case error = "error"
    }
}

// MARK: Модель персональных данных пользователя
struct UserPersonalData: Decodable {
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}

// MARK: Модель ошибки с сервера
struct UserError: Decodable {
    let errorCode: Int?
    let errorMsg: String?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMsg = "error_msg"
    }
}
