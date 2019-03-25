//
//  DebugFactory.swift
//  SwiftyBeaverTest
//
//  Created by Andrey on 21/03/2019.
//  Copyright © 2019 anddrrek. All rights reserved.
//

import UIKit
import MessageUI

final class DebugFactory {
    private init() { }
    
    static func showDebugWindow() -> UIWindow {
        let debugWindow = DebugWindow()
        let floatingButton = BugControl()
        let debugActionController = DebugActionController(window: debugWindow)
        floatingButton.actionController = debugActionController
        debugWindow.addSubview(floatingButton)
        
        return debugWindow
    }
    
    static func presentMailComposerOn(_ window: UIWindow) {
        let dataProvider = LogDataProvider()
        let controller = DebugViewController(logProvider: dataProvider)
        window.rootViewController?.present(controller,
                                           animated: true,
                                           completion: nil)
    }
}
