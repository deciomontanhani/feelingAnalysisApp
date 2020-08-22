//
//  AppCoordinator.swift
//  FeelingAnalysisApp
//
//  Created by Decio Montanhani on 20/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import UIKit

final class AppCoordinator {

    let window: UIWindow
    let navigation = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = navigation
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        let coordinator = TweetsListCoordinator(currentNavigationController: navigation)
        coordinator.start()
    }
}
