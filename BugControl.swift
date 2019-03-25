//
//  BugControl.swift
//  SwiftyBeaverTest
//
//  Created by Andrey on 20/03/2019.
//  Copyright © 2019 anddrrek. All rights reserved.
//

import UIKit

final class BugControl: UIView {
    //MARK: Constants
    private struct Appereance {
        static let icon = UIImage(named: "ic_debug")
        static let dimension: CGFloat = 50
        static let animationDuration: TimeInterval = 0.5
    }
    
    //MARK: Properties
    private var imageView: UIImageView = {
        let imageView = UIImageView(image: Appereance.icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var panRecognizer: UIPanGestureRecognizer!
    private let shouldStickToCorners = false
    var actionController: DebugActionController?
    
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init() {
        let originCoordiantate = Appereance.dimension / 2
        let frame = CGRect(x: originCoordiantate,
                           y: originCoordiantate,
                           width: Appereance.dimension,
                           height: Appereance.dimension)
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .red
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.frame = bounds
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
        addGestureRecognizer(panRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        addGestureRecognizer(tapRecognizer)
        
        alpha = 1

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    //MARK: Actions
    @objc private func tapHandler() {
        actionController?.showDebugOutput()
    }
    
    @objc private func panHandler(_ recognizer: UIPanGestureRecognizer) {
        guard let parentView = superview else { return }
        
        let minX = Appereance.dimension / 2
        let maxX = parentView.bounds.maxX - minX
        let minY = Appereance.dimension
        let maxY = parentView.bounds.maxY - minY
        
        let translation = recognizer.translation(in: self)
        let newCenter = center + translation
        let newCenterClamped = newCenter.clamp(minX: minX,
                                               maxX: maxX,
                                               minY: minY,
                                               maxY: maxY)
        
        center = newCenterClamped
        
        recognizer.setTranslation(.zero, in: self)
        
        guard shouldStickToCorners else { return }
        
        switch recognizer.state {
        case .ended,
             .failed,
             .cancelled:
            let leftTop = CGPoint(x: minX, y: minY)
            let leftBottom = CGPoint(x: minX, y: maxY)
            let rightTop = CGPoint(x: maxX, y: minY)
            let rightBottom = CGPoint(x: maxX, y: maxY)
            
            let chosenCorner = [leftTop,
                                leftBottom,
                                rightTop,
                                rightBottom].min(by: { corner1, corner2 in
                                    return corner1.distance(from: newCenterClamped) < corner2.distance(from: newCenterClamped)
                                })!
            
            UIView.animate(withDuration: Appereance.animationDuration,
                           animations: { [weak self] in
                            self?.center = chosenCorner
            })
        default:
            break
        }
    }
}

//MARK: Extensions
extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    func clamp(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) -> CGPoint {
        return CGPoint(x: self.x.clamp(min: minX, max: maxX), y: self.y.clamp(min: minY, max: maxY))
    }
    
    func distance(from other: CGPoint) -> CGFloat {
        let xDist = self.x - other.x
        let yDist = self.y - other.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}

extension CGFloat {
    func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
        if self < min { return min }
        if self > max { return max }
        return self
    }
}
