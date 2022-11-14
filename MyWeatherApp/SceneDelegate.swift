//
//  SceneDelegate.swift
//  MyWeatherApp
//
//  Created by Андрей on 19.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        LocationManager.shared.getLocation()
    }
}
