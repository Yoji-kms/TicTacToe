//
//  File.swift
//  TicTacToe
//
//  Created by Yoji on 04.09.2024.
//

import Foundation

struct Coordinates {
    let row: Int
    let column: Int
    
    var id: Int {
        return self.row * 3 + self.column
    }
}
