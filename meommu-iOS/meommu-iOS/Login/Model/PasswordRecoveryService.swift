//
//  PasswordRecoveryService.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/04.
//

import Foundation
import Alamofire

class PasswordRecoveryService {
    
    private let baseURL = "https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"
    
    // 이메일로 코드 요청 메서드
    func sendEmail(with email: String, completion: @escaping (Result<PasswordRecoveryResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/kindergartens/email/verification-request"
        
        let parameters: Parameters = [
            "email": email
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ["Content-Type": "application/x-www-form-urlencoded"])
            .validate(statusCode: 200..<500).responseDecodable(of: PasswordRecoveryResponse.self) { response in
                switch response.result {
                case .success(let responseData):
                    completion(.success(responseData))
                case .failure(_):
                    if let data = response.data, let apiError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        // 서버에서 에러 응답이 왔을 경우
                        completion(.failure(apiError))
                    } else {
                        // 서버에서 에러 응답이 아닌 다른 오류가 발생한 경우
                        completion(.failure(ErrorResponse(code: "UNKNOWN_ERROR", message: "알 수 없는 오류가 발생했습니다.", data: nil)))
                    }
                }
            }
    }
    
    func checkEmailCode(email: String, code: String, completion: @escaping (Result<EmailCodeResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/kindergartens/email/verification"
        
        let parameters: Parameters = [
            "email": email,
            "code": code
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"])
            .validate(statusCode: 200..<500)
            .responseDecodable(of: EmailCodeResponse.self) { response in
                switch response.result {
                case .success(let responseData):
                    
                    completion(.success(responseData))
                case .failure(_):
                    if let data = response.data, let apiError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        // 서버에서 에러 응답이 왔을 경우
                        completion(.failure(apiError))
                    } else {
                        // 서버에서 에러 응답이 아닌 다른 오류가 발생한 경우
                        completion(.failure(ErrorResponse(code: "UNKNOWN_ERROR", message: "알 수 없는 오류가 발생했습니다.", data: nil)))
                    }
                }
            }
        
    }
}
