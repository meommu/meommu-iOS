//
//  GPTDiaryAPI.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/16.
//

import Foundation
import Alamofire

class GPTDiaryAPI {
    
    static let shared = GPTDiaryAPI()
    
    private let baseURL = "https://comibird.site"
    
    
    //MARK: - GPT 일기 가이드 조회 메서드
    func getGPTDiaryGuide(completion: @escaping (Result<GPTDiaryGuideResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/guides"
        
        guard let authorizationHeader = KeyChain.shared.getAuthorizationHeader() else {
            return print("토큰 오류")
        }
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: authorizationHeader).validate(statusCode: 200..<500).responseDecodable(of: GPTDiaryGuideResponse.self) {
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
    
    func getGPTDiaryDetailGuide(guideId: Int, completion: @escaping (Result<GPTDiaryDetailGuideResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/guides/\(guideId)/details"
        
        guard let authorizationHeader = KeyChain.shared.getAuthorizationHeader() else {
            return print("토큰 오류")
        }
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: authorizationHeader).validate(statusCode: 200..<500).responseDecodable(of: GPTDiaryDetailGuideResponse.self) {
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
