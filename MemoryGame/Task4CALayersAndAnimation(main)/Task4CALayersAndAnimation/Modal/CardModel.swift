//
//  ModalCardView.swift
//  Task4CALayersAndAnimation
//
//  Created by Tymofii (Work) on 25.09.2021.
//

import Foundation
import UIKit

class CardModel {
    
    // MARK: - Data model
    
    var id = UUID().uuidString
    var image: UIImage
    var shown = false
    
    // MARK: - Initialization
    
    init(image: UIImage) {
        self.image = image
    }
    
    // MARK: - Copy card to create similar card
    
    func copy() -> CardModel {
        return CardModel(card: self)
    }
    
    // MARK: - Initialization for create similar card
    
    private init(card: CardModel) {
        self.id = card.id
        self.shown = card.shown
        self.image = card.image
    }
}
extension CardModel: Equatable {
    static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        lhs.id == rhs.id
    }
}
