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
}
