//
//  CharacterModel.swift
//  meommu-iOS
//
//  Created by 이예빈 on 2023/09/25.
//

import UIKit

struct Character {
    var image: String
}

extension Character {
    static var data = [
        Character(image: "char1"),
        Character(image: "char2"),
        Character(image: "char3"),
        Character(image: "char4"),
        Character(image: "char5"),
        Character(image: "char1")
    ]
}
