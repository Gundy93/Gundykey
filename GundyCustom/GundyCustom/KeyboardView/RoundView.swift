//
//  RoundView.swift
//  GundyCustom
//
//  Created by Gundy on 5/10/24.
//

import UIKit

final class RoundView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}
