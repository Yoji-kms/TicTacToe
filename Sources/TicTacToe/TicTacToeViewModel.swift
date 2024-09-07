//
//  File.swift
//  TicTacToe
//
//  Created by Yoji on 04.09.2024.
//

import Foundation

final class TicTacToeViewModel {
    private(set) var data = [CellModel]()
    
    init() {
        for id in 0..<9 {
            var cell = CellModel(coordinates: id.coordinates, mark: .none)
            data.append(cell)
        }
    }
    
    private func checkResult(competion: @escaping (Result)->Void) {
        let rowsResult = self.checkRows()
        let columnsResult = self.checkColumns()
        let diagonalsResult = self.checkDiagonals()
        
        if rowsResult.isFinal || columnsResult.isFinal || diagonalsResult.isFinal {
            if rowsResult.isFinal { competion(rowsResult) }
            if columnsResult.isFinal { competion(rowsResult) }
            if diagonalsResult.isFinal { competion(rowsResult) }
        } else {
            let tie = self.checkTie()
            if tie == .tie {
                competion(.tie)
            }
        }
        competion(.none)
    }
    
    private func checkRows() -> Result {
        for row in 0..<3 {
            let prefix = 3 * row
            if data[prefix] == data[prefix + 1] && data[prefix] == data [prefix + 2] {
                let result = self.checkBy(id: prefix)
                if result == .none {
                    continue
                }
                return result
            }
        }
        return .none
    }
    
    private func checkColumns() -> Result {
        for column in 0..<3 {
            if data[column] == data[column + 3] && data[column] == data[column + 6] {
                let result = self.checkBy(id: column)
                if result == .none {
                    continue
                }
                return result
            }
        }
        return .none
    }
    
    private func checkDiagonals() -> Result {
        let forwardDiagonal = self.data[4] == self.data[0] && self.data[4] == self.data[8]
        let backwardDiagonal = self.data[4] == self.data[2] && self.data[4] == self.data[6]
        
        if forwardDiagonal || backwardDiagonal {
            let result = self.checkBy(id: 4)
            return result
        }
        return .none
    }
    
    private func checkBy(id: Int) -> Result {
        switch data[id].mark {
        case .cross:
            return .win
        case .circle:
            return .loose
        case .none:
            return .none
        }
    }
    
    private func checkTie() -> Result {
        if self.data.contains(where: { $0.mark == .none }) {
            return .none
        } else {
            return .tie
        }
    }
    
    func replay(completion: @escaping ()->Void) {
        for id in 0..<9 {
            data[id].mark = .none
        }
        completion()
    }
    
    func cellDidTap(
        id: Int,
        completionAfterPlayersMove: @escaping (Result)->Void,
        completionAfterBotsMove: @escaping (Result, Int)->Void)
    {
        if data[id].mark == .none {
            data[id].mark = .cross
            self.checkResult() { [weak self] result in
                guard let self else { return }
                completionAfterPlayersMove(result)
                if !result.isFinal {
                    self.makeMove(completion: completionAfterBotsMove)
                }
            }
        }
    }
    
    private func makeMove(completion: @escaping (Result, Int)->Void) {
        let emptyCells = self.data.filter { $0.mark == .none }
        guard let randomEmptyCell = emptyCells.randomElement() else { return }
        let randomEmptyCellIndex = randomEmptyCell.coordinates.id
        self.data[randomEmptyCellIndex].mark = .circle
        self.checkResult() { [weak self] result in
            guard let self else { return }
            completion(result, randomEmptyCellIndex)
        }
    }
}

private extension Int {
    var coordinates: Coordinates {
        let row = self / 3
        let column = self % 3
        return Coordinates(row: row, column: column)
    }
}
