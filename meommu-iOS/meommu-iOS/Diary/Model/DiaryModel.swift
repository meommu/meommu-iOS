//
//  DiaryModel.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/18.
//

import UIKit


struct Diary {
    let diaryDate: String
    let diaryName: String
    let diaryTitle: String
    let diaryDetail: String
    let diaryImage: String
}

extension Diary {
    static var data =
    [
        Diary(diaryDate: "2023.09.07",
              diaryName: "돌돌이 일기",
              diaryTitle: "목욕 넘무 실허...",
              diaryDetail: "주인아,, 오늘 내가 지인짜 싫어하는 목욕하는 날이다. 다른 친구들은 신나보이더라 장난도 치고... 미니 쌤이 목욕 다하고 잘했다고 간식 주셔서 조금 기분이 나아졌어 내일도 목욕하는 거.. 아니지?",
              diaryImage: "image.png"),
        Diary(diaryDate: "2023.09.07",
              diaryName: "돌돌이 일기",
              diaryTitle: "목욕 넘무 실허...",
              diaryDetail: "주인아,, 오늘 내가 지인짜 싫어하는 목욕하는 날이다. 다른 친구들은 신나보이더라 장난도 치고... 미니 쌤이 목욕 다하고 잘했다고 간식 주셔서 조금 기분이 나아졌어 내일도 목욕하는 거.. 아니지?",
              diaryImage: "image.png"),
        Diary(diaryDate: "2023.09.07",
              diaryName: "돌돌이 일기",
              diaryTitle: "목욕 넘무 실허...",
              diaryDetail: "주인아,, 오늘 내가 지인짜 싫어하는 목욕하는 날이다. 다른 친구들은 신나보이더라 장난도 치고... 미니 쌤이 목욕 다하고 잘했다고 간식 주셔서 조금 기분이 나아졌어 내일도 목욕하는 거.. 아니지?",
              diaryImage: "image.png")
   ]
}
