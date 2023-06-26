//
//  cards.swift
//  Block Eleven
//
//  Created by 陳佩琪 on 2023/6/12.
//

import Foundation

enum Suit {
    case spade, heart, diamond, club
}

struct Card {
    let suit : Suit
    let rank : Int
    let image : String
    }




