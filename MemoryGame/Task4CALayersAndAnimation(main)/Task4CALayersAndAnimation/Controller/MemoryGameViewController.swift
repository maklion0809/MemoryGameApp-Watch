//
//  PlayGameViewController.swift
//  Task4CALayersAndAnimation
//
//  Created by Tymofii (Work) on 25.09.2021.
//

import UIKit

final class MemoryGameViewController: UIViewController {
    
    // MARK: - Configuration
        
    private enum Configuration {
        static let countCardByWidth: CGFloat = 4
        static let countCardByHeight: CGFloat = 4
        static let minimumInteritemSpacing: CGFloat = 10
        static let itemSpacing: CGFloat = 10
        static let recordIdentifier = "MyRecord"
        static let scoreMiss = -1
        static let scoreHit = 10
    }

    // MARK: - Variable
    
    private let memoryGame = MemoryGameModel()
    
    private var spaceFolderCards = 0
    private var score: Int = 0 {
        didSet {
            UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: [.curveEaseOut]) {
                if oldValue > self.score {
                    self.scoreLabel.transform = self.scoreLabel.transform.scaledBy(x: 0.5, y: 0.5)
                    self.scoreLabel.text = "Score: \(self.score)"
                    self.scoreLabel.transform = self.scoreLabel.transform.scaledBy(x: 2, y: 2)

                } else {
                    self.scoreLabel.transform = self.scoreLabel.transform.scaledBy(x: 4, y: 4)
                    self.scoreLabel.text = "Score: \(self.score)"
                    self.scoreLabel.transform = self.scoreLabel.transform.scaledBy(x: 0.5, y: 0.5)
                    self.scoreLabel.transform = self.scoreLabel.transform.scaledBy(x: 0.5, y: 0.5)
                }
            }
        }
    }
    
    // MARK: - UI element
    
    private lazy var playingFieldCollectionView: UICollectionView = returnPlayingFieldCollectionView()
    
    func returnPlayingFieldCollectionView() -> UICollectionView {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = Configuration.minimumInteritemSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        collectionView.layer.backgroundColor = UIColor.clear.cgColor
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }
    
    
    private lazy var restartButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Restart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var recordLabel: UILabel = {
        let label = UILabel()
        let record = UserDefaults.standard.integer(forKey: Configuration.recordIdentifier)
        label.text = "Record: \(record)"
        label.textColor = .white
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: \(score)"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var tabBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoryGame.delegate = self
        startGame()
        addBackground()
    }
    
    // MARK: - Setting up the subview
    
    private func setupSubview() {
        tabBarStackView.addArrangedSubview(restartButton)
        tabBarStackView.addArrangedSubview(recordLabel)
        view.addSubview(tabBarStackView)
        view.addSubview(playingFieldCollectionView)
        view.addSubview(scoreLabel)
        restartButton.addTarget(self, action: #selector(restartTheGame), for: .touchUpInside)
    }
    
    // MARK: - Setting up the constraint
    
    private func setupConstraint() {
        
        // Setting up the constraint for tabBarStackView
        
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBarStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Configuration.itemSpacing),
            tabBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Configuration.itemSpacing),
            tabBarStackView.bottomAnchor.constraint(equalTo: playingFieldCollectionView.topAnchor, constant: -Configuration.itemSpacing)
        ])
        
        // Setting up the constraint for playingFieldCollectionView
        
        playingFieldCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playingFieldCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Configuration.itemSpacing),
            playingFieldCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Configuration.itemSpacing),
            playingFieldCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Setting up the constraint for scoreLabel
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Setting up background
    
    private func addBackground() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "background")
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
    }
    
    // MARK: - UIAction
    
    @objc private func restartTheGame() {
        memoryGame.restartGame()
        startGame()
    }
    
    // MARK: - Function for start game
    
    private func startGame() {
        playingFieldCollectionView.removeFromSuperview()
        playingFieldCollectionView = returnPlayingFieldCollectionView()
        setupSubview()
        setupConstraint()
        
        score = 0
        spaceFolderCards = 0
        
        memoryGame.newGame()
    }
    
}

// MARK: - UICollectionViewDataSource

extension MemoryGameViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoryGame.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else { return CardCollectionViewCell() }
        guard let card = memoryGame.cardAtIndex(indexPath.item) else { return cardCell }
        cardCell.card = card
        UIView.animate(withDuration: 1) {
            cardCell.transform = cardCell.transform.rotated(by: Double.pi)
            cardCell.transform = cardCell.transform.rotated(by: Double.pi)
        }
        cardCell.isUserInteractionEnabled = true
        
        return cardCell
    }
}

// MARK: - UICollectionViewDelegate

extension MemoryGameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        if cell.isUserInteractionEnabled {
            cell.shown = true
            guard let card = cell.card else { return }
            memoryGame.didSelectCard(card)
            memoryGame.checkTheEndOfTheGame()
            cell.isUserInteractionEnabled = false
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MemoryGameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: (width - Configuration.countCardByWidth * Configuration.itemSpacing) / Configuration.countCardByWidth,
            height: (height - Configuration.countCardByHeight * Configuration.itemSpacing) / (Configuration.countCardByHeight + 1))
    }
    
}

// MARK: - MemoryGameProtocol

extension MemoryGameViewController: MemoryGameProtocol {

    func memoryGameDidStart(_ game: MemoryGameModel) {
        playingFieldCollectionView.reloadData()
    }
    
    func memoryGameDidEnd(_ game: MemoryGameModel) {
        let defaults = UserDefaults.standard
        let alert = UIAlertController(title: "You won!", message: "Your score \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert, animated: true)
        
        if defaults.integer(forKey: Configuration.recordIdentifier) < score {
            defaults.setValue(score, forKey: Configuration.recordIdentifier)
            recordLabel.text = "Record: \(score)"
        }
        
        memoryGame.restartGame()
        startGame()
    }
    
    func memoryGameShowCards(_ game: MemoryGameModel, showCards cards: [CardModel]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            guard let cell = playingFieldCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CardCollectionViewCell else { continue }
            cell.isUserInteractionEnabled = true
            cell.shown = true
        }
    }
    
    func memoryGameHideCards(_ game: MemoryGameModel, hideCards cards: [CardModel]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            guard let cell = playingFieldCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CardCollectionViewCell else { continue }
            cell.isUserInteractionEnabled = true
            cell.shown = false
        }
        score += Configuration.scoreMiss
    }
    
    func memoryGameSameCards(_ game: MemoryGameModel, sameCards cards: [CardModel]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            guard let cell = playingFieldCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? CardCollectionViewCell else { continue }
            cell.pushToCardStack(playingFieldCollectionView.frame.height, spaceFolderCards)
        }
        spaceFolderCards += 1
        score += Configuration.scoreHit
    }
}
