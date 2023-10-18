//
//  ViewController.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/15.
//

import UIKit

class ViewController: UIViewController {
    ///Outlets
    @IBOutlet weak var textField: UITextField!
    
    ///Variables
    var customKeyboardView: GundyKeyboardView!
    private var lastInput: KoreanType = .other
    private var lastWord: Character?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add CustomKeyboardView to the input view of text field
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
        let consonant = convertToUnicode(consonant: newCharacter,
                                         isInitialConsonanat: lastInput != .vowel)
        
        textField.insertText(consonant)
        lastInput = lastInput != .vowel ? .initialConsonant : .finalConsonant(character: newCharacter)
    }
    
    func insertVowel(_ newCharacter: String) {
        switch lastInput {
        case .finalConsonant(character: let consonant):
            guard let lastWord else { return }
            
            textField.deleteBackward()
            textField.insertText(String(lastWord))
            textField.insertText(convertToUnicode(consonant: consonant,
                                                  isInitialConsonanat: true))
        default:
            break
        }
        
        let vowel = convertToUnicode(vowel: newCharacter)
        
        textField.insertText(vowel)
        lastInput = .vowel
    }
    
    func insertOther(_ newCharacter: String) {
        textField.insertText(newCharacter)
        lastInput = .other
    }
    
    func removeCharacter() {
        textField.deleteBackward()
        lastInput = .other
    }
    
    private func convertToUnicode(consonant: String, isInitialConsonanat: Bool) -> String {
        if isInitialConsonanat == false {
            lastWord = textField.text?.last
        }
        
        switch consonant {
        case "ㄱ":
            return isInitialConsonanat ? "\u{1100}" : "\u{11A8}"
        case "ㄲ":
            return isInitialConsonanat ? "\u{1101}" : "\u{11A9}"
        case "ㄴ":
            return isInitialConsonanat ? "\u{1102}" : "\u{11AB}"
        case "ㄷ":
            return isInitialConsonanat ? "\u{1103}" : "\u{11AE}"
        case "ㄸ":
            return isInitialConsonanat ? "\u{1104}" : "\u{D7CD}"
        case "ㄹ":
            return isInitialConsonanat ? "\u{1105}" : "\u{11AF}"
        case "ㅁ":
            return isInitialConsonanat ? "\u{1106}" : "\u{11B7}"
        case "ㅂ":
            return isInitialConsonanat ? "\u{1107}" : "\u{11B8}"
        case "ㅃ":
            return isInitialConsonanat ? "\u{1108}" : "\u{D7E6}"
        case "ㅅ":
            return isInitialConsonanat ? "\u{1109}" : "\u{11BA}"
        case "ㅆ":
            return isInitialConsonanat ? "\u{110A}" : "\u{11BB}"
        case "ㅇ":
            return isInitialConsonanat ? "\u{110B}" : "\u{11BC}"
        case "ㅈ":
            return isInitialConsonanat ? "\u{110C}" : "\u{11BD}"
        case "ㅉ":
            return isInitialConsonanat ? "\u{110D}" : "\u{D7F9}"
        case "ㅊ":
            return isInitialConsonanat ? "\u{110E}" : "\u{11BE}"
        case "ㅋ":
            return isInitialConsonanat ? "\u{110F}" : "\u{11BF}"
        case "ㅌ":
            return isInitialConsonanat ? "\u{1110}" : "\u{11C0}"
        case "ㅍ":
            return isInitialConsonanat ? "\u{1111}" : "\u{11C1}"
        case "ㅎ":
            return isInitialConsonanat ? "\u{1112}" : "\u{11C2}"
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
