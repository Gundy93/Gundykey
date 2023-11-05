//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Gundy on 2023/10/15.
//

import UIKit

final class KeyboardViewController: UIInputViewController {

    private var customKeyboardView: GundyKeyboardView!
    private var lastInput: KoreanType = .other
    private var lastWords: [(text: String, type: KoreanType)] = []
    private var currentContextAfterInput: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInputView()
    }

    private func configureInputView() {
        let nib = UINib(nibName: "GundyKeyboardView",
                        bundle: nil)
        let objects = nib.instantiate(withOwner: nil,
                                      options: nil)
        
        customKeyboardView = objects.first as? GundyKeyboardView
        customKeyboardView.delegate = self
        customKeyboardView.inputModeSwitch.addTarget(self,
                                                     action: #selector(handleInputModeList(from:with:)),
                                                     for: .allTouchEvents)
        customKeyboardView.inputModeSwitch.isHidden = !self.needsInputModeSwitchKey
        customKeyboardView.inputModeSwitch.heightAnchor.constraint(equalToConstant: 40).isActive = true
        inputView = customKeyboardView
    }
}

extension KeyboardViewController: GundyKeyboardViewDelegate {
    
    var isRemovable: Bool {
        textDocumentProxy.hasText
    }
    
    func insertConsonant(_ newCharacter: String) {
        resetIfNeeded()
        
        let (consonant, isInitialConsonant) = convert(newCharacter)
        
        if isInitialConsonant {
            lastWords.removeAll()
        } else if lastInput != .neuter {
            textDocumentProxy.deleteBackward()
            textDocumentProxy.insertText(lastWords[0].text)
            textDocumentProxy.insertText(lastWords[1].text)
        }
        
        textDocumentProxy.insertText(consonant)
        lastInput = isInitialConsonant ? .initialConsonant : .finalConsonant(character: newCharacter)
        lastWords.append((consonant, lastInput))
        currentContextAfterInput = textDocumentProxy.documentContextAfterInput
    }
    
    func insertVowel(_ newCharacter: String) {
        resetIfNeeded()
        
        var vowel = newCharacter
        
        switch lastInput {
        case .initialConsonant:
            let consonant = lastWords[0].text.toUnicodeConsonant(isInitialConsonant: true)
            
            textDocumentProxy.deleteBackward()
            textDocumentProxy.insertText(consonant)
            lastWords[0].text = consonant
            
            vowel = vowel.toUnicodeVowel()
        case .finalConsonant(character: let consonant):
            textDocumentProxy.deleteBackward()
            for index in 0...lastWords.count - 2 {
                textDocumentProxy.insertText(lastWords[index].text)
            }
            insertConsonant(consonant.toUnicodeConsonant(isInitialConsonant: true))
            
            vowel = vowel.toUnicodeVowel()
        default:
            lastWords.removeAll()
            
            lastInput = .other
        }
        
        textDocumentProxy.insertText(vowel)
        
        if lastWords.isEmpty == false {
            lastInput = .neuter
            lastWords.append((vowel, .neuter))
        }
        currentContextAfterInput = textDocumentProxy.documentContextAfterInput
    }
    
    func insertOther(_ newCharacter: String) {
        textDocumentProxy.insertText(newCharacter)
        lastInput = .other
        lastWords.removeAll()
    }
    
    func pasteInto() {
        guard let currentText = UIPasteboard.general.string else { return }
        
        textDocumentProxy.insertText(currentText)
    }
    
    func removeCharacter() {
        textDocumentProxy.deleteBackward()
        let _ = lastWords.popLast()
        
        guard let last = lastWords.last else {
            lastInput = .other
            return
        }
        
        lastInput = last.type
        lastWords.forEach { textDocumentProxy.insertText($0.text) }
    }
    
    private func convert(_ newCharacter: String) -> (consonant: String, isInitialConsonant: Bool) {
        switch lastInput {
        case .neuter:
            let isInitialConsonant = ["ㄸ", "ㅃ", "ㅉ"].contains(newCharacter)
            return isInitialConsonant ? (newCharacter, isInitialConsonant) : (newCharacter.toUnicodeConsonant(isInitialConsonant: false), isInitialConsonant)
        case .finalConsonant(character: let finalConsonant):
            switch (finalConsonant, newCharacter) {
            case ("ㄱ", "ㅅ"):
                return ("\u{11AA}", false)
            case ("ㄴ", "ㅈ"):
                return ("\u{11AC}", false)
            case ("ㄴ", "ㅎ"):
                return ("\u{11AD}", false)
            case ("ㄹ", "ㄱ"):
                return ("\u{11B0}", false)
            case ("ㄹ", "ㅁ"):
                return ("\u{11B1}", false)
            case ("ㄹ", "ㅂ"):
                return ("\u{11B2}", false)
            case ("ㄹ", "ㅅ"):
                return ("\u{11B3}", false)
            case ("ㄹ", "ㅌ"):
                return ("\u{11B4}", false)
            case ("ㄹ", "ㅍ"):
                return ("\u{11B5}", false)
            case ("ㄹ", "ㅎ"):
                return ("\u{11B6}", false)
            case ("ㅂ", "ㅅ"):
                return ("\u{11B9}", false)
            default:
                return (newCharacter, true)
            }
        default:
            return (newCharacter, true)
        }
    }
    
    private func resetIfNeeded() {
        guard textDocumentProxy.hasText == false || currentContextAfterInput != textDocumentProxy.documentContextAfterInput else { return }
        
        lastInput = .other
        lastWords.removeAll()
    }
}
