//
//  Untitled.swift
//  TicTacToe
//
//  Created by Yoji on 04.09.2024.
//
import Foundation

enum Result {
    case win
    case loose
    case tie
    case none
    
    var isFinal: Bool {
        return switch self {
        case .win, .loose, .tie:
            true
        case .none:
            false
        }
    }
    
    var text: String {
        return switch self {
        case .win:
            String(localized: "Win")
//            NSLocalizedString("Win", comment: "Win")
        case .loose:
            String(localized: "Lost")
//            NSLocalizedString("Lost", comment: "Lost")
        case .tie:
            String(localized: "Tie")
//            NSLocalizedString("Tie", comment: "Tie")
        case .none:
            ""
        }
    }
}
