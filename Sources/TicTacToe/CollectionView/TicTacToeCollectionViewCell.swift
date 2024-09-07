//
//  File.swift
//  TicTacToe
//
//  Created by Yoji on 07.09.2024.
//

import UIKit

final class TicTacToeCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemTeal
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.imageView.image = UIImage()
    }
    
    func setup(with mark: Marks) {
        self.imageView.image = mark.image
    }
    
    private func setupView() {
        self.addSubview(self.imageView)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
