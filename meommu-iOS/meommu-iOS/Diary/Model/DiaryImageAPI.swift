//
//  DiaryImageAPI.swift
//  meommu-iOS
//
//  Created by zaehorang on 2024/01/20.
//

import Foundation
import Alamofire

class DiaryImageAPI {
    
    static let shared = DiaryImageAPI()
    
    private init() { }
    
    private let baseURL = "https://comibird.site"
    
    // 이미지 아이디 값으로 이미지 URL을 받는 메서드
    func getAllDiaryImage(with req: ImageRequest, completion: @escaping (Result<ImageResponse, ErrorResponse>) -> Void) {
        
        
        
        // id와 url을 캐쉬처리해서 캐쉬 저장되어 있으면 통신 안하고 리턴
        

        let url = "\(baseURL)/api/v1/images?" + req.imageIds.map { "id=\($0)" }.joined(separator: "&")
        
        AF.request(url, method: .get, encoding: URLEncoding.default).validate(statusCode: 200..<500).responseDecodable(of: ImageResponse.self) {
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
