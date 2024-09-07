// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public final class TicTacToeView: UIView {
//    MARK: Variables
    private let viewModel = TicTacToeViewModel()
    private let yourTurnString = NSLocalizedString("Your turn", comment: "Your turn")
    private let botsTurnString = NSLocalizedString("Bot’s turn", comment: "Bot’s turn")
    
//    MARK: Views
    private lazy var label: UILabel = {
        let text = self.yourTurnString
        let label = UILabel()
        label.text = text
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var replayButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "arrow.counterclockwise.circle")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(self.replayButtonDidTap), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.isScrollEnabled = false
        
//        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
//    MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Setups
    private func setupViews() {
        self.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.collectionView.heightAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
//    MARK: Actions
    @objc private func replayButtonDidTap() {
        self.viewModel.replay(){
            self.label.text = self.yourTurnString
            self.collectionView.reloadData()
        }
    }
}

//extension TicTacToeView: UICollectionViewDelegate {
//    
//}

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.allowsSelection = false
        self.viewModel.cellDidTap(id: indexPath.row) { [weak self] result in
            guard let self else { return }
            self.collectionView.reloadItems(at: [indexPath])
            self.label.text = result.isFinal ? result.text : self.botsTurnString
        } completionAfterBotsMove: { [weak self] result, index in
            guard let self else { return }
            let botsMoveIndexPath = IndexPath(row: index, section: 0)
            self.collectionView.reloadItems(at: [botsMoveIndexPath])
            if result.isFinal {
                self.label.text = result.text
            } else {
                self.label.text = yourTurnString
                self.collectionView.allowsSelection = true
            }
        }
    }
}
