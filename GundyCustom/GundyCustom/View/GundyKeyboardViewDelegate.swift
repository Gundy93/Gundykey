//
//  GundyKeyboardViewDelegate.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/16.
//

protocol GundyKeyboardViewDelegate: AnyObject {
    func insertConsonant(_ newCharacter: String)
    func insertVowels(_ newCharacter: String)
    func insertOther(_ newCharacter: String)
    func removeCharacter()
}
