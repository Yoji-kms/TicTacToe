//
//  File.swift
//  TicTacToe
//
//  Created by Yoji on 04.09.2024.
//

import UIKit

enum Marks {
    case cross
    case circle
    case none
    
    var image: UIImage {
        switch self {
        case .cross:
            return UIImage(named: "xmark") ?? UIImage()
        case .circle:
            return UIImage(named: "circle") ?? UIImage()
        case .none:
            return UIImage()
        }
    }
}
