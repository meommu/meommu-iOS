//
//  LoginAPI.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/11/27.
//

import Alamofire
import Foundation

class LoginAPI {
    
    static let shared = LoginAPI()
    
    private let baseURL = "https://comibird.site"
    
    // 로그인 요청 메서드
    func login(with request: LoginRequest, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/kindergartens/signin"
        
        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: ["Content-Type": "application/json;charset=UTF-8", "Content-Length": "62", "Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"])
            .validate(statusCode: 200..<500)
            .responseDecodable(of: LoginResponse.self) { response in
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
    
    
    // 액세스 토큰으로 로그인 정보 조회
    func getAccessTokenLogin(completion: @escaping (Result<TokenVerificationResponse, ErrorResponse>) -> Void) {

        let url = "\(baseURL)/api/v1/kindergartens/me"
        
        guard let authorizationHeader = KeyChain.shared.getAuthorizationHeader() else {
            return print("토큰 오류")
        }

        AF.request(url, method: .get, encoding: URLEncoding.default, headers: authorizationHeader).validate(statusCode: 200..<500).responseDecodable(of: TokenVerificationResponse.self) {
            response in
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
