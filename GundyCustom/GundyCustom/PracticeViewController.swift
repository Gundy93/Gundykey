//
//  PracticeViewController.swift
//  GundyCustom
//
//  Created by Gundy on 10/26/23.
//

import UIKit

final class PracticeViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        
        return scrollView
    }()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = Constant.description
        label.numberOfLines = 0
        
        return label
    }()
    private let practiceTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = Constant.placeHolder
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    private var customKeyboardView: GundyKeyboardView!
    private var lastInput: KoreanType = .other
    private var lastWords: [(text: String, type: KoreanType)] = []
    private var lastIndex: UITextRange?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureInputView()
        configureLayoutConstraint()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        [descriptionLabel, practiceTextField].forEach { subView in
            contentStackView.addArrangedSubview(subView)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            scrollView.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor, constant: -8),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func configureInputView() {
        let nib = UINib(nibName: "GundyKeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        
        customKeyboardView = objects.first as? GundyKeyboardView
        customKeyboardView.delegate = self
        customKeyboardView.inputModeSwitch.isHidden = true
        practiceTextField.inputView = customKeyboardView
    }
    
    private func configureLayoutConstraint() {
        scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
    }
}

extension PracticeViewController: GundyKeyboardViewDelegate {
    
    var isRemovable: Bool {
        return practiceTextField.text?.isEmpty == false
    }
    
    func insertConsonant(_ newCharacter: String) {
        resetIfNeeded()
        
        let (consonant, isInitialConsonant) = convert(newCharacter)
        
        if isInitialConsonant {
            lastWords.removeAll()
        } else if lastInput != .neuter {
            practiceTextField.deleteBackward()
            practiceTextField.insertText(lastWords[0].text)
            practiceTextField.insertText(lastWords[1].text)
        }
        
        practiceTextField.insertText(consonant)
        lastInput = isInitialConsonant ? .initialConsonant : .finalConsonant(character: newCharacter)
        lastWords.append((consonant, lastInput))
        lastIndex = practiceTextField.selectedTextRange
    }
    
    func insertVowel(_ newCharacter: String) {
        resetIfNeeded()
        
        var vowel = newCharacter
        switch lastInput {
        case .initialConsonant:
            let consonant = lastWords[0].text.toUnicodeConsonant(isInitialConsonant: true)
            
            practiceTextField.deleteBackward()
            practiceTextField.insertText(consonant)
            lastWords[0].text = consonant
            
            vowel = vowel.toUnicodeVowel()
        case .finalConsonant(character: let consonant):
            practiceTextField.deleteBackward()
            for index in 0...lastWords.count - 2 {
                practiceTextField.insertText(lastWords[index].text)
            }
            insertConsonant(consonant.toUnicodeConsonant(isInitialConsonant: true))
            
            vowel = vowel.toUnicodeVowel()
        default:
            lastWords.removeAll()
            
            lastInput = .other
        }
        
        practiceTextField.insertText(vowel)
        if lastWords.isEmpty == false {
            lastInput = .neuter
            lastWords.append((vowel, .neuter))
        }
        lastIndex = practiceTextField.selectedTextRange
    }
    
    func insertOther(_ newCharacter: String) {
        practiceTextField.insertText(newCharacter)
        lastInput = .other
        lastWords.removeAll()
    }
    
    func removeCharacter() {
        practiceTextField.deleteBackward()
        let _ = lastWords.popLast()
        
        guard let last = lastWords.last else {
            lastInput = .other
            return
        }
        
        lastInput = last.type
        lastWords.forEach { practiceTextField.insertText($0.text) }
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
        guard practiceTextField.selectedTextRange != lastIndex else { return }
        
        lastInput = .other
        lastWords.removeAll()
    }
}

extension PracticeViewController {
    
    enum Constant {
        
        static let description: String = """
                                         키보드를 추가하는 방법은 다음과 같습니다.
                                         
                                         설정 > 일반 > 키보드 > 키보드 > 새로운 키보드 추가 > 타사 키보드의 건디 키보드를 선택합니다.
                                         
                                         키보드를 추가하지 않아도 이 페이지에서 사용해 볼 수 있습니다.
                                         """
        static let placeHolder: String = "키보드를 사용해 보세요"
    }
}
