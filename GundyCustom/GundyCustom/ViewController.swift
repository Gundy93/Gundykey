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
        
        let keyboardContainerView = UIView(frame: customKeyboardView.frame)
        
        keyboardContainerView.addSubview(customKeyboardView)
        textField.inputView = keyboardContainerView
    }
    
    private func configureLayoutConstraint() {
        scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
    }
}

extension ViewController: GundyKeyboardViewDelegate {
    
    func insertConsonant(_ newCharacter: String) {
        let isInitialConsonant = lastInput != .vowel || ["ㄸ", "ㅃ", "ㅉ"].contains(newCharacter)
        let consonant = isInitialConsonant ? newCharacter : newCharacter.toUnicodeConsonant(isInitialConsonant: false)
        
        if isInitialConsonant {
            lastWords.removeAll()
        }
        
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
            
            insertConsonant(consonant)
        default:
            break
        }
        
        var vowel = newCharacter
        
        if lastInput == .initialConsonant {
            let consonant = lastWords[0].text.toUnicodeConsonant(isInitialConsonant: true)
            
            textField.deleteBackward()
            textField.insertText(consonant)
            lastWords[0].text = consonant
            
            vowel = vowel.toUnicodeVowel()
        } else {
            lastWords.removeAll()
        }
        
        textField.insertText(vowel)
        lastInput = .vowel
        if lastWords.isEmpty == false {
            lastWords.append((vowel, .vowel))
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
}
