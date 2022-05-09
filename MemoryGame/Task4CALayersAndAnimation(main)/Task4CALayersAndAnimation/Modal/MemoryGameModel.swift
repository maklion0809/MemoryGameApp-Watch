//
//  MemoryGameModel.swift
//  Task4CALayersAndAnimation
//
//  Created by Tymofii (Work) on 26.09.2021.
//

import UIKit

class MemoryGameModel {
    
    // MARK: - Configuration
        
    private enum Configuration {
        static let numberOfCardsInTheSame = 2
        static let defaultCardImages: [UIImage] = [
            UIImage(named: "frontCardOne")!,
            UIImage(named: "frontCardTwo")!,
            UIImage(named: "frontCardThree")!,
            UIImage(named: "frontCardFour")!,
            UIImage(named: "frontCardFive")!,
            UIImage(named: "frontCardSix")!,
            UIImage(named: "frontCardSeven")!,
            UIImage(named: "frontCardEight")!
        ]
    }
    
    // MARK: - Data model
    
    var delegate: MemoryGameProtocol?
    var cards: [CardModel] = []
    var shownCards: [CardModel] = []
    var isPlaying = false
    
    // MARK: - Start game
    
    func newGame() {
        isPlaying = true
        for image in Configuration.defaultCardImages {
            let card = CardModel(image: image)
            let cardCopy = card.copy()
            cards.append(card)
            cards.append(cardCopy)
        }
        self.cards = cards.shuffled()
        delegate?.memoryGameDidStart(self)
    }
    
    // MARK: - Comparisons by address
    
    func indexForCard(_ card: CardModel) -> Int? {
        for index in 0...cards.count - 1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }
    
    // MARK: - Returning an item by index
    
    func cardAtIndex(_ index: Int) -> CardModel? {
        if cards.count > index {
            return cards[index]
        } else {
            return nil
        }
    }
    
    // MARK: - Checking cards
    
    func didSelectCard(_ card: CardModel) {

        delegate?.memoryGameShowCards(self, showCards: [card])

        guard shownCards.count % Configuration.numberOfCardsInTheSame != 0 else {             shownCards.append(card)
            return
        }
        guard let lastShown = shownCards.last else { return }
        guard card == lastShown else {
            let secondCard = shownCards.removeLast()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.delegate?.memoryGameHideCards(self, hideCards: [card, secondCard])
            }
            return
        }
        
        shownCards.append(card)
        self.delegate?.memoryGameSameCards(self, sameCards: [lastShown, card])
    }
    
    func checkTheEndOfTheGame() {
        if shownCards.count == cards.count {
            endGame()
        }
    }
    
    // MARK: - Restart game
    
    func restartGame() {
        isPlaying = false
        cards.removeAll()
        shownCards.removeAll()
    }
    
    // MARK: - End game
    
    func endGame() {
        isPlaying = false
        delegate?.memoryGameDidEnd(self)
    }
}
