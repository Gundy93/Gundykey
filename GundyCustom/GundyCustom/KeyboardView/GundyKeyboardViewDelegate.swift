//
//  GundyKeyboardViewDelegate.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/16.
//

protocol GundyKeyboardViewDelegate: AnyObject {
    
    var isRemovable: Bool { get }
    
    func insertConsonant(_ newCharacter: String)
    func insertVowel(_ newCharacter: String)
    func insertOther(_ newCharacter: String)
    func removeCharacter()
    func switchInputMode()
}

extension GundyKeyboardViewDelegate {
    
    func switchInputMode() {}
}
