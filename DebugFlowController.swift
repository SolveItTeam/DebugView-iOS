//
//  DebugFlowController.swift
//  SwiftyBeaverTest
//
//  Created by Andrey on 21/03/2019.
//  Copyright © 2019 anddrrek. All rights reserved.
//

import UIKit

final class DebugFlowController {
    
    private let window: UIWindow
    private let floatingButton: BugControl
    
    required init(window: UIWindow, floatingButton: BugControl) {
        self.window = window
        self.floatingButton = floatingButton
    }
    
    func showDebugView() {
        DebugFactory.presentMailComposerOn(window)
    }
}
