//
//  ViewController.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/15.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    
    private var customKeyboardView: GundyKeyboardView!
    private var lastInput: KoreanType = .other
    private var lastWords: [(text: String, type: KoreanType)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInputView()
        configureLayoutConstraint()
    }
    
    private func configureInputView() {
        let nib = UINib(nibName: "GundyKeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        
        customKeyboardView = objects.first as? GundyKeyboardView
        customKeyboardView.delegate = self
        customKeyboardView.inputModeSwitch.isHidden = true
        textField.inputView = customKeyboardView
    }
    
    private func configureLayoutConstraint() {
        scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
    }
}

extension ViewController: GundyKeyboardViewDelegate {
    
    var isRemovable: Bool {
        return textField.text?.isEmpty == false
    }
    
    func insertConsonant(_ newCharacter: String) {
        let (consonant, isInitialConsonant) = convert(newCharacter)
        
        if isInitialConsonant {
            lastWords.removeAll()
        } else if lastInput != .neuter {
            textField.deleteBackward()
            textField.insertText(lastWords[0].text)
            textField.insertText(lastWords[1].text)
        }
        
        textField.insertText(consonant)
        lastInput = isInitialConsonant ? .initialConsonant : .finalConsonant(character: newCharacter)
        lastWords.append((consonant, lastInput))
    }
    
    func insertVowel(_ newCharacter: String) {
        var vowel = newCharacter
        switch lastInput {
        case .initialConsonant:
            let consonant = lastWords[0].text.toUnicodeConsonant(isInitialConsonant: true)
            
            textField.deleteBackward()
            textField.insertText(consonant)
            lastWords[0].text = consonant
            
            vowel = vowel.toUnicodeVowel()
        case .finalConsonant(character: let consonant):
            textField.deleteBackward()
            for index in 0...lastWords.count - 2 {
                textField.insertText(lastWords[index].text)
            }
            insertConsonant(consonant.toUnicodeConsonant(isInitialConsonant: true))
            
            vowel = vowel.toUnicodeVowel()
        default:
            lastWords.removeAll()
            
            lastInput = .other
        }
        
        textField.insertText(vowel)
        if lastWords.isEmpty == false {
            lastInput = .neuter
            lastWords.append((vowel, .neuter))
        }
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
}
