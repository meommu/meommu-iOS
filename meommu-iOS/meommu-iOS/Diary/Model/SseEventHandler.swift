//
//  SseEventHandler.swift
//  meommu-iOS
//
//  Created by zaehorang on 2024/01/19.
//

import Foundation
import LDSwiftEventSource

class SseEventHandler: EventHandler {

    func onOpened() {
        // SSE 연결 성공시 처리 로직 작성
        print("SSE 연결 성공")
    }

    func onClosed() {
        // SSE 연결 종료시 처리 로직 작성
        print("SSE 연결 종료")
    }

    func onMessage(eventType: String, messageEvent: MessageEvent) {
        // SSE 이벤트 도착시 처리 로직 작성
        
        // eventType: String = 이벤트가 속한 채널 또는 토픽 이름
        // messageEvent.lastEventId: String = 도착한 이벤트 ID
        // messageEvent.data: String = 도착한 이벤트 데이터
        print("입령한다~~")
        print(eventType)
        print(messageEvent)
        print("다음 입력 준비~~")
        
        
    }

    func onComment(comment: String) {
    }

    func onError(error: Error) {
        // SSE 연결 전 또는 후 오류 발생시 처리 로직 작성
        print(error)
        // error.responseCode: Int = 오류 응답 코드
    }
}

