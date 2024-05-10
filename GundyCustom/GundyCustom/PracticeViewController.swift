//
//  PracticeViewController.swift
//  GundyCustom
//
//  Created by Gundy on 11/2/23.
//

import UIKit

final class PracticeViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.keyboardDismissMode = .onDrag
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
    private let practiceLabel: UILabel = {
        let label = UILabel()
        
        label.text = Constant.practice
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
    private var lastWords: [(text: Int, type: KoreanType)] = []
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
        [practiceLabel, practiceTextField].forEach { subView in
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
        let objects = nib.instantiate(withOwner: nil)
        
        customKeyboardView = objects.first as? GundyKeyboardView
        customKeyboardView.delegate = self
        customKeyboardView.inputModeSwitch.forEach { $0.isHidden = true }
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
            lastWords.append((consonant, .initialConsonant))
            practiceTextField.insertText(newCharacter)
        } else {
            lastWords.append((consonant, .finalConsonant(character: newCharacter)))
            practiceTextField.deleteBackward()
            practiceTextField.insertText(makeWord())
        }
        
        lastInput = isInitialConsonant ? .initialConsonant : .finalConsonant(character: newCharacter)
        lastIndex = practiceTextField.selectedTextRange
    }
    
    func insertVowel(_ newCharacter: String) {
        resetIfNeeded()
        
        var text = newCharacter
        
        switch lastInput {
        case .initialConsonant:
            practiceTextField.deleteBackward()
            lastWords.append((text.toUnicodeVowel(), .neuter))
            text = makeWord()
        case .finalConsonant(character: let consonant):
            practiceTextField.deleteBackward()
            lastWords.removeLast()
            practiceTextField.insertText(makeWord())
            lastWords.removeAll()
            lastWords.append((consonant.toUnicodeConsonant(isInitialConsonant: true), .initialConsonant))
            lastWords.append((text.toUnicodeVowel(), .neuter))
            text = makeWord()
        default:
            lastWords.removeAll()
            lastInput = .other
        }
        
        practiceTextField.insertText(text)
        
        if lastWords.isEmpty == false {
            lastInput = .neuter
        }
        
        lastIndex = practiceTextField.selectedTextRange
    }
    
    func insertOther(_ newCharacter: String) {
        practiceTextField.insertText(newCharacter)
        lastInput = .other
        lastWords.removeAll()
    }
    
    func moveCursor(for direction: GundyKeyboardView.Direction) {
        
    }
    
    func pasteInto() {
        guard let currentText = UIPasteboard.general.string else { return }
        
        practiceTextField.insertText(currentText)
    }
    
    func removeCharacter() {
        practiceTextField.deleteBackward()
        let _ = lastWords.popLast()
        
        guard let last = lastWords.last else {
            lastInput = .other
            
            return
        }
        
        lastInput = last.type
        
        if lastWords.count == 1 {
            practiceTextField.insertText(last.text.toConsonant())
        } else {
            practiceTextField.insertText(makeWord())
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
        guard practiceTextField.selectedTextRange != lastIndex else { return }
        
        lastInput = .other
        lastWords.removeAll()
    }
}

extension PracticeViewController {
    
    enum Constant {
        
        static let practice: String = "키보드를 추가하거나 전체 접근 허용을 하지 않아도 모든 기능을 이 페이지에서 사용해 볼 수 있습니다."
        static let placeHolder: String = "키보드를 사용해 보세요"
    }
}
