// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public final class TicTacToeView: UIView {
//    MARK: Variables
    private let viewModel = TicTacToeViewModel()
    
//    MARK: Views
    private lazy var label: UILabel = {
        let text = ""
        let label = UILabel()
        label.text = text
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var replayButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.counterclockwise.circle")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(self.replayButtonDidTap), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let width = self.frame.width * 0.9
        let layout = CollectionViewLayout(collectionViewWidth: width)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.isScrollEnabled = false
        collectionView.register(TicTacToeCollectionViewCell.self, forCellWithReuseIdentifier: "TicTacToeCollectionViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
//    MARK: Lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Setups
    private func setupViews() {
        self.addSubview(self.label)
        self.addSubview(self.replayButton)
        self.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            self.label.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            
            self.replayButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.replayButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.replayButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            self.replayButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            
            self.collectionView.topAnchor.constraint(equalTo: self.label.bottomAnchor),
            self.collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.collectionView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            self.collectionView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9)
        ])
    }
    
//    MARK: Actions
    @objc private func replayButtonDidTap() {
        self.viewModel.replay(){
            self.label.text = ""
            self.collectionView.reloadData()
            self.collectionView.allowsSelection = true
        }
    }
}

extension TicTacToeView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicTacToeCollectionViewCell", for: indexPath) as? TicTacToeCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }

        cell.setup(with: self.viewModel.data[indexPath.row].mark)
        
        return cell
    }
}

extension TicTacToeView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.allowsSelection = false
        self.viewModel.cellDidTap(id: indexPath.row) { [weak self] result, index in
            guard let self else { return }
            self.collectionView.reloadItems(at: [indexPath])
            if index >= 0 {
                let botsMoveIndexPath = IndexPath(row: index, section: 0)
                self.collectionView.reloadItems(at: [botsMoveIndexPath])
            }
            if result.isFinal {
                self.label.text = result.text
            } else {
                self.collectionView.allowsSelection = true
            }
        } completionIfCellNotEmpty: {
            self.collectionView.allowsSelection = true
        }
    }
}
