//
//  ViewController.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/15.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    private var customKeyboardView: GundyKeyboardView!
    private var lastInput: KoreanType = .other
    private var lastWords: [(text: String, type: KoreanType)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInputView()
    }

    private func configureInputView() {
        let nib = UINib(nibName: "GundyKeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        
        customKeyboardView = objects.first as? GundyKeyboardView
        customKeyboardView.delegate = self
        
        let keyboardContainerView = UIView(frame: customKeyboardView.frame)
        
        keyboardContainerView.addSubview(customKeyboardView)
        textField.inputView = keyboardContainerView
    }
}

extension ViewController: GundyKeyboardViewDelegate {
    
    func insertConsonant(_ newCharacter: String) {
        let isInitialConsonant = lastInput != .vowel || ["ㄸ", "ㅃ", "ㅉ"].contains(newCharacter)
        let consonant = convertToUnicode(consonant: newCharacter,
                                         isInitialConsonant: isInitialConsonant)
        
        textField.insertText(consonant)
        lastInput = isInitialConsonant ? .initialConsonant : .finalConsonant(character: newCharacter)
        lastWords.append((consonant, lastInput))
    }
    
    func insertVowel(_ newCharacter: String) {
        switch lastInput {
        case .finalConsonant(character: let consonant):
            textField.deleteBackward()
            textField.insertText(lastWords[0].text)
            textField.insertText(lastWords[1].text)
            
            let initialConsonant = convertToUnicode(consonant: consonant,
                                                    isInitialConsonant: true)
            
            textField.insertText(initialConsonant)
            lastWords.append((initialConsonant, .initialConsonant))
        default:
            break
        }
        
        let vowel = convertToUnicode(vowel: newCharacter)
        
        textField.insertText(vowel)
        lastInput = .vowel
        lastWords.append((vowel, .vowel))
    }
    
    func insertOther(_ newCharacter: String) {
        textField.insertText(newCharacter)
        lastInput = .other
        lastWords.removeAll()
    }
    
    func removeCharacter() {
        textField.deleteBackward()
        let _ = lastWords.popLast()
        
        guard let last = lastWords.last else {
            lastInput = .other
            return
        }
        
        lastInput = last.type
        lastWords.forEach { textField.insertText($0.text) }
    }
    
    private func convertToUnicode(consonant: String, isInitialConsonant: Bool) -> String {
        if isInitialConsonant {
            lastWords.removeAll()
        }
        switch consonant {
        case "ㄱ":
            return isInitialConsonant ? "\u{1100}" : "\u{11A8}"
        case "ㄲ":
            return isInitialConsonant ? "\u{1101}" : "\u{11A9}"
        case "ㄴ":
            return isInitialConsonant ? "\u{1102}" : "\u{11AB}"
        case "ㄷ":
            return isInitialConsonant ? "\u{1103}" : "\u{11AE}"
        case "ㄸ":
            return "\u{1104}"
        case "ㄹ":
            return isInitialConsonant ? "\u{1105}" : "\u{11AF}"
        case "ㅁ":
            return isInitialConsonant ? "\u{1106}" : "\u{11B7}"
        case "ㅂ":
            return isInitialConsonant ? "\u{1107}" : "\u{11B8}"
        case "ㅃ":
            return "\u{1108}"
        case "ㅅ":
            return isInitialConsonant ? "\u{1109}" : "\u{11BA}"
        case "ㅆ":
            return isInitialConsonant ? "\u{110A}" : "\u{11BB}"
        case "ㅇ":
            return isInitialConsonant ? "\u{110B}" : "\u{11BC}"
        case "ㅈ":
            return isInitialConsonant ? "\u{110C}" : "\u{11BD}"
        case "ㅉ":
            return "\u{110D}"
        case "ㅊ":
            return isInitialConsonant ? "\u{110E}" : "\u{11BE}"
        case "ㅋ":
            return isInitialConsonant ? "\u{110F}" : "\u{11BF}"
        case "ㅌ":
            return isInitialConsonant ? "\u{1110}" : "\u{11C0}"
        case "ㅍ":
            return isInitialConsonant ? "\u{1111}" : "\u{11C1}"
        case "ㅎ":
            return isInitialConsonant ? "\u{1112}" : "\u{11C2}"
        default:
            return String()
        }
    }
    
    private func convertToUnicode(vowel: String) -> String {
        switch vowel {
        case "ㅏ":
            return "\u{1161}"
        case "ㅐ":
            return "\u{1162}"
        case "ㅑ":
            return "\u{1163}"
        case "ㅒ":
            return "\u{1164}"
        case "ㅓ":
            return "\u{1165}"
        case "ㅔ":
            return "\u{1166}"
        case "ㅕ":
            return "\u{1167}"
        case "ㅖ":
            return "\u{1168}"
        case "ㅗ":
            return "\u{1169}"
        case "ㅘ":
            return "\u{116A}"
        case "ㅙ":
            return "\u{116B}"
        case "ㅚ":
            return "\u{116C}"
        case "ㅛ":
            return "\u{116D}"
        case "ㅜ":
            return "\u{116E}"
        case "ㅝ":
            return "\u{116F}"
        case "ㅞ":
            return "\u{1170}"
        case "ㅟ":
            return "\u{1171}"
        case "ㅠ":
            return "\u{1172}"
        case "ㅡ":
            return "\u{1173}"
        case "ㅢ":
            return "\u{1174}"
        case "ㅣ":
            return "\u{1175}"
        default:
            return String()
        }
    }
}
