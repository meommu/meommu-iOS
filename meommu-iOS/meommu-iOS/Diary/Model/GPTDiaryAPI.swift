//
//  GPTDiaryAPI.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/16.
//

import Foundation
import Alamofire
import LDSwiftEventSource

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
    
    //MARK: - GPT 일기 가이드 디테일 조회 메서드
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
    
    //MARK: - 일기 가이드 전체 결과 조회 메서드
    func getGPTDiary(with request: GuideDataRequest, completion: @escaping (Result<GPTDiaryResponse, ErrorResponse>) -> Void) {
        let url = "\(baseURL)/api/v1/gpt"
        
        guard var authorizationHeader = KeyChain.shared.getAuthorizationHeader() else {
            return print("토큰 오류")
        }
        
        authorizationHeader["Content-Type"] = "application/json;charset=UTF-8"
        authorizationHeader["Host"] = "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"
        
        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: authorizationHeader)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: GPTDiaryResponse.self) { response in
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
    
    func createSSEEventSource(details: String, handler: EventHandler) -> EventSource? {
        
        // GuideDataRequest를 사용하여 요청 객체 생성
        let request = GuideDataRequest(details: details)
        
        // Guard 구문을 통해 토큰을 읽어오고, 실패하면 종료
        guard let token = KeyChain.shared.read(key: KeyChain.shared.accessTokenKey) else {
            return nil
        }
        
        // EventSource.Config 생성
        var config = EventSource.Config(handler: handler, url: URL(string: "https://comibird.site/api/v1/gpt/stream")!)
        
        // 커스텀 요청 헤더 추가
        config.headers = ["Content-Type": "application/json;charset=UTF-8", "Authorization": "Bearer \(token)", "Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"]
        
        // HTTP 메서드 설정
        config.method = "POST"
        
        // JSONEncoder를 사용하여 구조체를 JSON 데이터로 인코딩
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(request) else {
            fatalError("Failed to encode GuideDataRequest to JSON")
        }
        
        // HTTP 요청 본문 추가
        config.body = jsonData
        
        // 최대 연결 유지 시간 설정
        config.idleTimeout = 300.0
        
        // EventSource 인스턴스 생성 및 반환
        return EventSource(config: config)
    }
    
}
