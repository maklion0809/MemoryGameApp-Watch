//
//  MemoryGameProtocol.swift
//  Task4CALayersAndAnimation
//
//  Created by Tymofii (Work) on 28.09.2021.
//

import Foundation

// MARK: - Game control protocol

protocol MemoryGameProtocol {
    func memoryGameDidStart(_ game: MemoryGameModel)
    func memoryGameDidEnd(_ game: MemoryGameModel)
    func memoryGameShowCards(_ game: MemoryGameModel, showCards cards: [CardModel])
    func memoryGameHideCards(_ game: MemoryGameModel, hideCards cards: [CardModel])
    func memoryGameSameCards(_ game: MemoryGameModel, sameCards cards: [CardModel])
}
