//
//  KeyButton.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/16.
//

import UIKit

final class KeyButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViewHierarchy()
    }
    
    private func configureViewHierarchy() {
        configureShadow()
        
        addSubview(previewLabel)
        
        NSLayoutConstraint.activate([
            previewLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            previewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }
    
    private func configureShadow() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 0
    }
    
    func setPreviewLabel() {
        guard let text = titleLabel?.text else { return }
        
        var shortcut = UIPasteboard(name: UIPasteboard.Name(text), create: false)?.string
        
        if shortcut == nil || shortcut?.isEmpty == true {
            shortcut = text.defaultShortcut
        }
        
        guard let firstText = shortcut?.first else { return }
        
        previewLabel.text = String(firstText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        KeyButton.selectionFeedbackGenerator.selectionChanged()
    }
}

extension KeyButton {
    
    static let selectionFeedbackGenerator: UISelectionFeedbackGenerator = {
        let generator = UISelectionFeedbackGenerator()
        
        generator.prepare()
        
        return generator
    }()
}
