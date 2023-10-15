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
    let diaryImage: [String]
}

extension Diary {
    static var data =
    [
        Diary(diaryDate: "2023.09.07",
              diaryName: "돌돌이 일기",
              diaryTitle: "목욕 넘무 실허...",
              diaryDetail: "날씨가 너무 좋아! 오늘은 나의 일기를 써볼까? 아침에 일어나서 주인이 나에게 큰 허그를 줬어. 그건 정말로 좋았어! 그리고 나는 배가 너무 고팠어, 그래서 주인이 나에게 맛있는 간식을 줬어. 그 간식은 정말로 맛있었어! 나는 바깥으로 나가서 산책을 하기로 했어. 바깥은 너무 멋지고 재미있어! 냄새가 너무 많이 나서 주위를 돌아다니기만 해도 행복해지는 거야. 주인과 함께 뛰어놀면서 제일 좋아하는 공을 찾았어. 그런데 주인이 공을 던져주면서 \"가져와!\"라고 말할 때마다 나는 최선을 다해 공을 빨리 가져다 주려고 뛰어다녔어.",
              diaryImage: ["image.png", "image2.png", "image3.png"]),
        Diary(diaryDate: "2023.09.07",
              diaryName: "돌돌이 일기",
              diaryTitle: "목욕 넘무 실허...",
              diaryDetail: "주인아,, 오늘 내가 지인짜 싫어하는 목욕하는 날이다. 다른 친구들은 신나보이더라 장난도 치고... 미니 쌤이 목욕 다하고 잘했다고 간식 주셔서 조금 기분이 나아졌어 내일도 목욕하는 거.. 아니지?",
              diaryImage: ["image.png", "image2.png", "image3.png"]),
        Diary(diaryDate: "2023.09.07",
              diaryName: "돌돌이 일기",
              diaryTitle: "목욕 넘무 실허...",
              diaryDetail: "주인아,, 오늘 내가 지인짜 싫어하는 목욕하는 날이다. 다른 친구들은 신나보이더라 장난도 치고... 미니 쌤이 목욕 다하고 잘했다고 간식 주셔서 조금 기분이 나아졌어 내일도 목욕하는 거.. 아니지?",
              diaryImage: ["image.png", "image2.png", "image3.png"]),
        Diary(diaryDate: "2023.09.07",
              diaryName: "돌돌이 일기",
              diaryTitle: "목욕 넘무 실허...",
              diaryDetail: "주인아,, 오늘 내가 지인짜 싫어하는 목욕하는 날이다. 다른 친구들은 신나보이더라 장난도 치고... 미니 쌤이 목욕 다하고 잘했다고 간식 주셔서 조금 기분이 나아졌어 내일도 목욕하는 거.. 아니지?",
              diaryImage: ["image4.png"]),
        Diary(diaryDate: "2023.09.07",
              diaryName: "돌돌이 일기",
              diaryTitle: "목욕 넘무 실허...",
              diaryDetail: "주인아,, 오늘 내가 지인짜 싫어하는 목욕하는 날이다. 다른 친구들은 신나보이더라 장난도 치고... 미니 쌤이 목욕 다하고 잘했다고 간식 주셔서 조금 기분이 나아졌어 내일도 목욕하는 거.. 아니지?",
              diaryImage: ["image5.png"])
   ]
}
