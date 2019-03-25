//
//  DebugWindow.swift
//  SwiftyBeaverTest
//
//  Created by Andrey on 21/03/2019.
//  Copyright © 2019 anddrrek. All rights reserved.
//

import UIKit

// This class is inspired by:
// https://stackoverflow.com/a/34835333/2786606

final class DebugWindow: UIWindow {
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    override init(frame: CGRect) {
        fatalError("not implemented")
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
        isHidden = false
        windowLevel = Level(rawValue: CGFloat.greatestFiniteMagnitude)
        rootViewController = UIViewController()
    }
    
    //MARK: Touches
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews
            .filter { [weak self] subview in
                guard let strongSelf = self,
                    let rootViewController = strongSelf.rootViewController else { return false }
                return subview != rootViewController.view
            }.first { subview in
                let subviewPoint = convert(point, to: subview)
                return subview.point(inside: subviewPoint, with: event)
            } != nil
    }
}
