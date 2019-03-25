//
//  DebugViewModel.swift
//  SwiftyBeaverTest
//
//  Created by Andrey on 21/03/2019.
//  Copyright © 2019 anddrrek. All rights reserved.
//

import UIKit

final class DebugActionController {
    private let window: UIWindow
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    func showDebugOutput() {
        DebugFactory.presentMailComposerOn(window)
    }
}
