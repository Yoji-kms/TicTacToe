//
//  File.swift
//  TicTacToe
//
//  Created by Yoji on 07.09.2024.
//

import UIKit

final class CollectionViewLayout: UICollectionViewFlowLayout {
    private let spacing: CGFloat = 4
    private let width: CGFloat
    
    init(collectionViewWidth width: CGFloat) {
        self.width = width
        super.init()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let columnsNumber: CGFloat = 3
        let widthWithPadding = self.width - (self.spacing * 2)
        let itemWidth = (widthWithPadding - self.spacing * (columnsNumber - 1)) / columnsNumber
        self.minimumLineSpacing = self.spacing
        self.minimumInteritemSpacing = spacing
        self.sectionInset = UIEdgeInsets(
            top: self.spacing,
            left: self.spacing,
            bottom: self.spacing,
            right: self.spacing
        )
        self.scrollDirection = .vertical
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
}
