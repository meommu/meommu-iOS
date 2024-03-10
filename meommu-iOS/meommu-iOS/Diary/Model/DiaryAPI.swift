//
//  .swift
//  meommu-iOS
//
//  Created by zaehorang on 2024/01/20.
//

import Foundation
import Alamofire

class DiaryAPI {
    
    static let shared = DiaryAPI()
    
    private init() { }
    
    private let baseURL = "https://comibird.site"
    
    //MARK: 일기 전체 조회 메서드
    func getAllDiary(with date: AllDiaryRequest, completion: @escaping (Result<AllDiaryResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/diaries?year=\(date.year)&month=\(date.month)"
        
        guard let authorizationHeader = KeyChain.shared.getAuthorizationHeader() else {
            return print("토큰 오류")
        }
        
        AF.request(url, method: .get, encoding: URLEncoding.default , headers: authorizationHeader).validate(statusCode: 200..<500).responseDecodable(of: AllDiaryResponse.self) {
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
    
    //MARK: 일기 삭제 메서드
    func deletDiary(withId diaryId: Int, completion: @escaping (Result<DeleteDiaryResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/diaries/\(diaryId)"
        
        guard let authorizationHeader = KeyChain.shared.getAuthorizationHeader() else {
            return print("토큰 오류")
        }
        
        AF.request(url, method: .delete, headers: authorizationHeader).validate(statusCode: 200..<500).responseDecodable(of: DeleteDiaryResponse.self) { response in
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
    
    //MARK: 일기 생성 메서드
    func createDiary(with diary: DiaryCreateRequest, completion: @escaping (Result<DiaryCreateResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/diaries"
        
        guard let authorizationHeader = KeyChain.shared.getAuthorizationHeader() else {
            return print("토큰 오류")
        }
        
        
        AF.request(url, method: .post, parameters: diary.toDictionary, encoding: JSONEncoding.default, headers: authorizationHeader).validate(statusCode: 200..<300).responseDecodable(of: DiaryCreateResponse.self) { response in
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
    
    //MARK: 일기 수정 메서드
    func editDiary(diaryId: Int, with diary: DiaryEditRequest, completion: @escaping (Result<DiaryEditResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/diaries/\(diaryId)"
        
        guard let authorizationHeader = KeyChain.shared.getAuthorizationHeader() else {
            return print("토큰 오류")
        }
        
        AF.request(url,
                   method: .put,
                   parameters: diary.toDictionary,
                   encoding: JSONEncoding.default,
                   headers: authorizationHeader)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: DiaryEditResponse.self) { response in
            switch response.result {
            case .success(let responseData):
                completion(.success(responseData))
            case .failure(_):
                if let data = response.data, let apiError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    // 서버에서 에러 응답이 왔을 경우
                    completion(.failure(apiError))
                } else {
                    // 서버에서 에러 응답이 아닌 다른 오류가 발생한 경우
                    completion(.failure(ErrorResponse(code: "UNKNOWN_ERROR0000", message: "알 수 없는 오류가 발생했습니다.", data: nil)))
                }
            }
        }
        
    }
    
    // 일기 UUID 생성 메서드
    func makeDiaryUUID(diaryId: Int, completion: @escaping (Result<DiaryUUIDResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/diaries/\(diaryId)/share-uuid"
        
        guard let authorizationHeader = KeyChain.shared.getAuthorizationHeader() else {
            return print("토큰 오류")
        }
        
        AF.request(url, method: .get, encoding: URLEncoding.default , headers: authorizationHeader).validate(statusCode: 200..<500).responseDecodable(of: DiaryUUIDResponse.self) {
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
