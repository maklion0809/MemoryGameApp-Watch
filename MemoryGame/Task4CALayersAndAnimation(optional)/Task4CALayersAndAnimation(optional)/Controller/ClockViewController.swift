//
//  ClockViewController.swift
//  Task4CALayersAndAnimation(optional)
//
//  Created by Tymofii (Work) on 29.09.2021.
//

import UIKit

class ClockViewController: UIViewController {
    
    // MARK: - Configuration
    
    enum Configuration {
        static let clockSize = CGSize(width: 300, height: 300)
    }
    
    let containerView: ClockView = {
        let view = ClockView()
        view.backgroundColor = .black
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 15
        view.layer.shadowOffset = .init(width: 10, height: 10)
        view.layer.shadowRadius = 15
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 0.5
        view.clipsToBounds = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let widthView: CGFloat = Configuration.clockSize.width
        let heightView: CGFloat = Configuration.clockSize.height
        
        containerView.frame = CGRect(x: view.frame.midX - widthView / 2, y: view.frame.midY - heightView / 2, width: widthView, height: heightView)
        view.addSubview(containerView)
                
    }
}
