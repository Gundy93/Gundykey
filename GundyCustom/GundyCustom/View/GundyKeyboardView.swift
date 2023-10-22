//
//  GundyKeyboardView.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/16.
//

import UIKit

final class GundyKeyboardView: UIView {
    
    weak var delegate: GundyKeyboardViewDelegate?
    private var vowels: [String] = ["ㅗ", "ㅣ", "ㅏ", "ㅡ", "ㅜ", "ㅡ", "ㅓ", "ㅣ"]
    private var directions: [Direction] = []
    private var isBeganEditing: Bool = false
    private var timer: Timer?
    private var startPoint: CGPoint?
    private var lastDirection: Direction?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureGestureRecognizer()
    }
    
    private func configureGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                             action: #selector(drag))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(longPressRemove))
        
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc
    private func drag(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self)
        
        guard isBeganEditing,
              let direction = convertToDirection(x: velocity.x,
                                                 y: velocity.y) else { return }
        let point = sender.location(in: self)
        
        switch sender.state {
        case .began:
            startPoint = point
            lastDirection = direction
        case .changed:
            guard directions.count < 4,
                  let startPoint else { return }
            
            guard lastDirection?.isSimilar(direction: direction) == false else {
                lastDirection = convertToDirection(x: point.x - startPoint.x,
                                                   y: point.y - startPoint.y)
                return
            }
            
            recordDirection(for: point)
        case .ended:
            recordDirection(for: point)
            inputVowel()
        default:
            return
        }
    }
    
    @objc
    private func longPressRemove(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            timer?.invalidate()
        }
    }
    
    private func recordDirection(for point: CGPoint) {
        guard let startPoint else { return }
        
        let x = point.x - startPoint.x
        let y = point.y - startPoint.y
        
        guard abs(x) + abs(y) > 10,
              let direction = convertToDirection(x: x,
                                                 y: y) else { return }
              
        directions.append(direction)
        self.startPoint = point
        lastDirection = nil
    }
    
    private func inputVowel() {
        var vowel = vowels[directions[0].rawValue]
        
        if directions.count > 1 {
            vowel = secondInput(with: vowel)
        }
        
        if directions.count > 2 {
            vowel = thirdInput(with: vowel)
        }
        
        if directions.count == 4 {
            vowel = forthInput(with: vowel)
        }
        
        isBeganEditing = false
        directions.removeAll()
        delegate?.insertVowel(vowel)
    }
    
    private func secondInput(with vowel: String) -> String {
        switch vowel {
        case "ㅏ":
            return "ㅐ"
        case "ㅓ":
            return "ㅔ"
        case "ㅗ":
            return directions[1] == .right ? "ㅘ" : "ㅚ"
        case "ㅜ":
            return directions[1] == .left ? "ㅝ" : "ㅟ"
        case "ㅡ":
            return "ㅢ"
        default:
            return vowel
        }
    }
    
    private func thirdInput(with vowel: String) -> String {
        switch vowel {
        case "ㅐ":
            return "ㅑ"
        case "ㅔ":
            return "ㅕ"
        case "ㅚ":
            return "ㅛ"
        case "ㅟ":
            return "ㅠ"
        case "ㅘ":
            return directions[2] != .up ? "ㅙ" : vowel
        case "ㅝ":
            return directions[2] != .down ? "ㅞ" : vowel
        default:
            return vowel
        }
    }
    
    private func forthInput(with vowel: String) -> String {
        switch vowel {
        case "ㅑ":
            return "ㅒ"
        case "ㅕ":
            return "ㅖ"
        default:
            return vowel
        }
    }
}

extension GundyKeyboardView {
    
    enum Direction: Int {
        case up
        case rightUp
        case right
        case rightDown
        case down
        case leftDown
        case left
        case leftUp
        
        func isSimilar(direction: Direction) -> Bool {
            switch self {
            case .up:
                return [Direction.leftUp, Direction.up, Direction.rightUp].contains(direction)
            case .rightUp:
                return [Direction.up, Direction.rightUp, Direction.right].contains(direction)
            case .right:
                return [Direction.rightUp, Direction.right, Direction.rightDown].contains(direction)
            case .rightDown:
                return [Direction.right, Direction.rightDown, Direction.down].contains(direction)
            case .down:
                return [Direction.rightDown, Direction.down, Direction.leftDown].contains(direction)
            case .leftDown:
                return [Direction.down, Direction.leftDown, Direction.left].contains(direction)
            case .left:
                return [Direction.leftDown, Direction.left, Direction.leftUp].contains(direction)
            case .leftUp:
                return [Direction.left, Direction.leftUp, Direction.up].contains(direction)
            }
        }
    }
    
    private func convertToDirection(x: CGFloat, y: CGFloat) -> Direction? {
        if abs(x) / 2.414 >= abs(y) {
            return x > 0 ? .right : .left
        } else if abs(y) / 2.414 >= abs(x) {
            return y > 0 ? .down : .up
        } else if x > 0 {
            return y > 0 ? .rightDown : .rightUp
        } else {
            return y > 0 ? .leftDown : .leftUp
        }
    }
}

extension GundyKeyboardView {
    
    @IBAction func inputConsonant(_ sender: KeyButton) {
        guard let consonant = sender.titleLabel?.text else { return }
        
        delegate?.insertConsonant(consonant)
    }
    
    @IBAction func inputVowel(_ sender: KeyButton) {
        isBeganEditing = true
    }
    
    @IBAction func inputOther(_ sender: KeyButton) {
        guard let other = sender.titleLabel?.text else { return }
        
        delegate?.insertOther(other)
    }
    
    @IBAction func inputSpace(_ sender: KeyButton) {
        delegate?.insertOther(" ")
    }
    
    @IBAction func removeCharacter(_ sender: KeyButton) {
        delegate?.removeCharacter()
        timer?.invalidate()
    }
    
    @IBAction func didBeginRemove(_ sender: KeyButton) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                     repeats: false) { [weak self] _ in 
            self?.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self?.delegate?.removeCharacter()
            }
        }
    }
}
