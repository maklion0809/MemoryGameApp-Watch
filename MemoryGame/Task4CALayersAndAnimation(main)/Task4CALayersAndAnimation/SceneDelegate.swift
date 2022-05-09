//
//  SceneDelegate.swift
//  Task4CALayersAndAnimation
//
//  Created by Tymofii (Work) on 25.09.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MemoryGameViewController()
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

