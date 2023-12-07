//
//  UserProfileService.swift
//  meommu-iOS
//
//  Created by zaehorang on 2023/12/08.
//

import Foundation
import Alamofire

class UserProfileService {
    
    private let baseURL = "https://port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"
    
    let accessToken = KeyChain.shared.read(key: KeyChain.shared.accessTokenKey)
    
    func withdrawalUserProfile(completion: @escaping (Result<UserWithdrawalResponse, ErrorResponse>) -> Void) {
        
        let url = "\(baseURL)/api/v1/kindergartens"
        guard let accessToken = accessToken else { return }
        
        
        AF.request(url, method: .delete, encoding: URLEncoding.default, headers: ["Authorization": "Bearer \(accessToken)",
                                                                                  "Host": "port-0-meommu-api-jvvy2blm5wku9j.sel5.cloudtype.app"]).validate(statusCode: 200..<500).responseDecodable(of: UserWithdrawalResponse.self) { response in
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
