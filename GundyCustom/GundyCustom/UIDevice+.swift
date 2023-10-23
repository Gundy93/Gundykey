//
//  UIDevice+.swift
//  GundyCustom
//
//  Created by Gundy on 10/24/23.
//

import UIKit
import AudioToolbox

extension UIDevice {
    
    func playDeleteClick() {
        AudioServicesPlaySystemSound(1155)
    }
    
    func playModifierClick() {
        AudioServicesPlaySystemSound(1156)
    }
}
