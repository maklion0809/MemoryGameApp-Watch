//
//  CardCollectionViewCell.swift
//  Task4CALayersAndAnimation
//
//  Created by Tymofii (Work) on 27.09.2021.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "CardCell"
    
    // MARK: - Configuration
        
    private enum Configuration {
        static var xIndent = 5
    }
    
    // MARK: - UI element
    
    lazy var frontImageView: UIImageView = {
        let width = bounds.width
        let height = bounds.height
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    lazy var backImageView: UIImageView = {
        let width = bounds.width
        let height = bounds.height
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.image = UIImage(named: "launchScreen")
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    // MARK: - Variable
    
    var card: CardModel? {
        didSet{
            guard let card = card else { return }
            frontImageView.image = card.image
        }
    }
    
    var shown: Bool = false {
        didSet {
            UIView.transition(
                from: shown ? backImageView : frontImageView,
                to: shown ? frontImageView : backImageView,
                duration: 0.5,
                options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor
        layer.shadowOffset = .init(width: 5, height: 5)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.5
        
        frontImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(frontImageView)
        NSLayoutConstraint.activate([
            frontImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            frontImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            frontImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            frontImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backImageView)
        NSLayoutConstraint.activate([
            backImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Сard transfer function
    
    func pushToCardStack(_ heightCollectionView: CGFloat, _ numberOfMatches: Int) {
        let cellFrameX = self.frame.origin.x
        let cellFrameY = self.frame.origin.y
        let cellheight = self.bounds.height
        
        UIView.animate(withDuration: 4,
                       delay: 1,
                       options: [.curveEaseOut]) {
            self.frontImageView.transform = self.frontImageView.transform.translatedBy(
                x: -cellFrameX + CGFloat(Configuration.xIndent * numberOfMatches),
                y: heightCollectionView - cellFrameY - cellheight)
        }
    }
}
