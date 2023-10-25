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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureShadow()
    }
    
    private func configureShadow() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 0
    }
}
