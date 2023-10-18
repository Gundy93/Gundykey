//
//  String+.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/18.
//

extension String {
    
    func toUnicodeConsonant(isInitialConsonant: Bool) -> String {
        switch self {
        case "ㄱ":
            return isInitialConsonant ? "\u{1100}" : "\u{11A8}"
        case "ㄲ":
            return isInitialConsonant ? "\u{1101}" : "\u{11A9}"
        case "ㄴ":
            return isInitialConsonant ? "\u{1102}" : "\u{11AB}"
        case "ㄷ":
            return isInitialConsonant ? "\u{1103}" : "\u{11AE}"
        case "ㄸ":
            return "\u{1104}"
        case "ㄹ":
            return isInitialConsonant ? "\u{1105}" : "\u{11AF}"
        case "ㅁ":
            return isInitialConsonant ? "\u{1106}" : "\u{11B7}"
        case "ㅂ":
            return isInitialConsonant ? "\u{1107}" : "\u{11B8}"
        case "ㅃ":
            return "\u{1108}"
        case "ㅅ":
            return isInitialConsonant ? "\u{1109}" : "\u{11BA}"
        case "ㅆ":
            return isInitialConsonant ? "\u{110A}" : "\u{11BB}"
        case "ㅇ":
            return isInitialConsonant ? "\u{110B}" : "\u{11BC}"
        case "ㅈ":
            return isInitialConsonant ? "\u{110C}" : "\u{11BD}"
        case "ㅉ":
            return "\u{110D}"
        case "ㅊ":
            return isInitialConsonant ? "\u{110E}" : "\u{11BE}"
        case "ㅋ":
            return isInitialConsonant ? "\u{110F}" : "\u{11BF}"
        case "ㅌ":
            return isInitialConsonant ? "\u{1110}" : "\u{11C0}"
        case "ㅍ":
            return isInitialConsonant ? "\u{1111}" : "\u{11C1}"
        case "ㅎ":
            return isInitialConsonant ? "\u{1112}" : "\u{11C2}"
        default:
            return String()
        }
    }
    
    func toUnicodeVowel() -> String {
        switch self {
        case "ㅏ":
            return "\u{1161}"
        case "ㅐ":
            return "\u{1162}"
        case "ㅑ":
            return "\u{1163}"
        case "ㅒ":
            return "\u{1164}"
        case "ㅓ":
            return "\u{1165}"
        case "ㅔ":
            return "\u{1166}"
        case "ㅕ":
            return "\u{1167}"
        case "ㅖ":
            return "\u{1168}"
        case "ㅗ":
            return "\u{1169}"
        case "ㅘ":
            return "\u{116A}"
        case "ㅙ":
            return "\u{116B}"
        case "ㅚ":
            return "\u{116C}"
        case "ㅛ":
            return "\u{116D}"
        case "ㅜ":
            return "\u{116E}"
        case "ㅝ":
            return "\u{116F}"
        case "ㅞ":
            return "\u{1170}"
        case "ㅟ":
            return "\u{1171}"
        case "ㅠ":
            return "\u{1172}"
        case "ㅡ":
            return "\u{1173}"
        case "ㅢ":
            return "\u{1174}"
        case "ㅣ":
            return "\u{1175}"
        default:
            return String()
        }
    }
    
    func toTextFromUnicode() -> String {
        switch self {
        case "\u{1100}":
            return "ㄱ"
        case "\u{1101}":
            return "ㄲ"
        case "\u{1102}":
            return "ㄴ"
        case "\u{1103}":
            return "ㄷ"
        case "\u{1104}":
            return "ㄸ"
        case "\u{1105}":
            return "ㄹ"
        case "\u{1106}":
            return "ㅁ"
        case "\u{1107}":
            return "ㅂ"
        case "\u{1108}":
            return "ㅃ"
        case "\u{1109}":
            return "ㅅ"
        case "\u{110A}":
            return "ㅆ"
        case "\u{110B}":
            return "ㅇ"
        case "\u{110C}":
            return "ㅈ"
        case "\u{110D}":
            return "ㅉ"
        case "\u{110E}":
            return "ㅊ"
        case "\u{110F}":
            return "ㅋ"
        case "\u{1110}":
            return "ㅌ"
        case "\u{1111}":
            return "ㅍ"
        case "\u{1112}":
            return "ㅎ"
        default:
            return String()
        }
    }
}
