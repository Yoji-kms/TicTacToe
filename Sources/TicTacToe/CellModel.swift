//
//  File.swift
//  TicTacToe
//
//  Created by Yoji on 04.09.2024.
//

import Foundation

struct CellModel {
    let coordinates: Coordinates
    var mark: Marks
    
    static func == (lhs: CellModel, rhs: CellModel) -> Bool {
        lhs.mark == rhs.mark
    }
}
