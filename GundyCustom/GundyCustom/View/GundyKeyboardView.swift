//
//  GundyKeyboardView.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/16.
//

import UIKit

final class GundyKeyboardView: UIView {
    
    weak var delegate: GundyKeyboardViewDelegate?
    private var directions: [Direction] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureGestureRecognizer()
    }
    
    private func configureGestureRecognizer() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                             action: #selector(inputVowels))
        
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    private func inputVowels(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self)
        guard let direction = convertToDirection(from: velocity),
              directions.last != direction else { return }
        
        
    }
}

extension GundyKeyboardView {
    
    enum Direction {
        case up
        case rightUp
        case right
        case rightDown
        case down
        case leftDown
        case left
        case leftUp
    }
    
    private func convertToDirection(from velocity: CGPoint) -> Direction? {
        let x = velocity.x
        let y = velocity.y
        
        if abs(x) / 4.1421 >= abs(y) {
            return x > 0 ? .right : .left
        } else if abs(y) / 4.1421 >= abs(x) {
            return y > 0 ? .down : .up
        } else if x > 0 {
            return y > 0 ? .rightDown : .rightUp
        } else {
            return y > 0 ? .leftDown : .leftUp
        }
    }
}
