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
    private var lastWords: [(text: Int, type: KoreanType)] = []
    private var currentContextAfterInput: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInputView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customKeyboardView.setPreview()
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
            lastWords.append((consonant, .initialConsonant))
            textDocumentProxy.insertText(newCharacter)
        } else {
            lastWords.append((consonant, .finalConsonant(character: newCharacter)))
            textDocumentProxy.deleteBackward()
            textDocumentProxy.insertText(makeWord())
        }
        
        lastInput = isInitialConsonant ? .initialConsonant : .finalConsonant(character: newCharacter)
        currentContextAfterInput = textDocumentProxy.documentContextAfterInput
    }
    
    func insertVowel(_ newCharacter: String) {
        resetIfNeeded()
        
        var text = newCharacter
        
        switch lastInput {
        case .initialConsonant:
            textDocumentProxy.deleteBackward()
            lastWords.append((text.toUnicodeVowel(), .neuter))
            text = makeWord()
        case .finalConsonant(character: let consonant):
            textDocumentProxy.deleteBackward()
            lastWords.removeLast()
            textDocumentProxy.insertText(makeWord())
            lastWords.removeAll()
            lastWords.append((consonant.toUnicodeConsonant(isInitialConsonant: true), .initialConsonant))
            lastWords.append((text.toUnicodeVowel(), .neuter))
            text = makeWord()
        default:
            lastWords.removeAll()
            lastInput = .other
        }
        
        textDocumentProxy.insertText(text)
        
        if lastWords.isEmpty == false {
            lastInput = .neuter
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
        
        if lastWords.count == 1 {
            textDocumentProxy.insertText(last.text.toConsonant())
        } else {
            textDocumentProxy.insertText(makeWord())
        }
    }
    
    private func convert(_ newCharacter: String) -> (consonant: Int, isInitialConsonant: Bool) {
        switch lastInput {
        case .neuter:
            let isInitialConsonant = ["ㄸ", "ㅃ", "ㅉ"].contains(newCharacter)
            return (newCharacter.toUnicodeConsonant(isInitialConsonant: isInitialConsonant), isInitialConsonant)
        case .finalConsonant(character: let finalConsonant):
            switch (finalConsonant, newCharacter) {
            case ("ㄱ", "ㅅ"):
                return (4522, false)
            case ("ㄴ", "ㅈ"):
                return (4524, false)
            case ("ㄴ", "ㅎ"):
                return (4525, false)
            case ("ㄹ", "ㄱ"):
                return (4528, false)
            case ("ㄹ", "ㅁ"):
                return (4529, false)
            case ("ㄹ", "ㅂ"):
                return (4530, false)
            case ("ㄹ", "ㅅ"):
                return (4531, false)
            case ("ㄹ", "ㅌ"):
                return (4532, false)
            case ("ㄹ", "ㅍ"):
                return (4533, false)
            case ("ㄹ", "ㅎ"):
                return (4534, false)
            case ("ㅂ", "ㅅ"):
                return (4537, false)
            default:
                return (newCharacter.toUnicodeConsonant(isInitialConsonant: true), true)
            }
        default:
            return (newCharacter.toUnicodeConsonant(isInitialConsonant: true), true)
        }
    }
    
    private func makeWord() -> String {
        var number = 44032 + ((lastWords[0].text - 4352) * 588) + ((lastWords[1].text - 4449) * 28)
        
        switch lastWords.count {
        case 3:
            number += lastWords[2].text - 4519
        case 4:
            number += lastWords[3].text - 4519
        default:
            break
        }
        
        return String(UnicodeScalar(number)!)
    }
    
    private func resetIfNeeded() {
        guard textDocumentProxy.hasText == false || currentContextAfterInput != textDocumentProxy.documentContextAfterInput else { return }
        
        lastInput = .other
        lastWords.removeAll()
    }
}
