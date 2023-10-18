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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureGestureRecognizer()
    }
    
    private func configureGestureRecognizer() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                             action: #selector(drag))
        
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc
    private func drag(_ sender: UIPanGestureRecognizer) {
        guard isBeganEditing else { return }
        
        switch sender.state {
        case .changed:
            guard directions.count < 4 else { return }
            
            let velocity = sender.velocity(in: self)
            
            recordDirection(for: velocity)
        case .ended:
            inputVowel()
        default:
            return
        }
    }
    
    private func recordDirection(for velocity: CGPoint) {
        let direction = convertToDirection(from: velocity)
        guard let last = directions.last else {
            directions.append(direction)
            return
        }
        
        switch direction {
        case .up:
            guard last != .up, last != .leftUp, last != .rightUp else { return }
        case .rightUp:
            guard last != .rightUp, last != .up, last != .right else { return }
        case .right:
            guard last != .right, last != .rightUp, last != .rightDown else { return }
        case .rightDown:
            guard last != .rightDown, last != .right, last != .down else { return }
        case .down:
            guard last != .down, last != .rightDown, last != .leftDown else { return }
        case .leftDown:
            guard last != .leftDown, last != .down, last != .left else { return }
        case .left:
            guard last != .left, last != .leftDown, last != .leftUp else { return }
        case .leftUp:
            guard last != .leftUp, last != .left, last != .up else { return }
        }
        
        directions.append(direction)
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
    }
    
    private func convertToDirection(from velocity: CGPoint) -> Direction {
        let x = velocity.x
        let y = velocity.y
        
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
    }
}
