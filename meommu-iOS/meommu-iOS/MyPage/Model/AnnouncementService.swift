//
//  AnnouncementService.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/08.
//

import Foundation
import Alamofire

struct AnnouncementService {
    
    private let baseURL = "https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"
    
    func requestAnnouncment(completion: @escaping (Result<AnnouncmentResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/notices"
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: ["Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"])
            .validate(statusCode: 200..<500)
            .responseDecodable(of: AnnouncmentResponse.self) { response in
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
//
//func checkEmailDuplication(with request: CheckEmailDuplicationRequest, completion: @escaping (Result<CheckEmailDuplicationResponse, ErrorResponse>) -> Void) {
//
//    let url = "\(baseURL)/api/v1/kindergartens/email"
//
//    guard let email = request.email else {
//        print("이메일 오류")
//        return
//    }
//
//    let parameters: Parameters = [
//        "email": email
//    ]
//
//
//    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"])
//        .validate(statusCode: 200..<500)
//        .responseDecodable(of: CheckEmailDuplicationResponse.self) { response in
//            switch response.result {
//            case .success(let responseData):
//
//                completion(.success(responseData))
//            case .failure(_):
//                if let data = response.data, let apiError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
//                    // 서버에서 에러 응답이 왔을 경우
//                    completion(.failure(apiError))
//                } else {
//                    // 서버에서 에러 응답이 아닌 다른 오류가 발생한 경우
//                    completion(.failure(ErrorResponse(code: "UNKNOWN_ERROR", message: "알 수 없는 오류가 발생했습니다.", data: nil)))
//                }
//            }
//        }
//}
