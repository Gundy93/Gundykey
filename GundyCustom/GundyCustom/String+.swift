//
//  String+.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/18.
//

extension String {
    
    var defaultShortcut: String {
        switch self {
        case "ㅃ":
            return "1"
        case "ㅉ":
            return "2"
        case "ㄸ":
            return "3"
        case "ㄲ":
            return "4"
        case "ㅆ":
            return "5"
        case "ㅂ":
            return "6"
        case "ㅈ":
            return "7"
        case "ㄷ":
            return "8"
        case "ㄱ":
            return "9"
        case "ㅅ":
            return "0"
        default:
            return ""
        }
    }
    
    func toUnicodeConsonant(isInitialConsonant: Bool) -> Int {
        switch self {
        case "ㄱ":
            return isInitialConsonant ? 4352 : 4520
        case "ㄲ":
            return isInitialConsonant ? 4353 : 4521
        case "ㄴ":
            return isInitialConsonant ? 4354 : 4523
        case "ㄷ":
            return isInitialConsonant ? 4355 : 4526
        case "ㄸ":
            return 4356
        case "ㄹ":
            return isInitialConsonant ? 4357 : 4527
        case "ㅁ":
            return isInitialConsonant ? 4358 : 4535
        case "ㅂ":
            return isInitialConsonant ? 4359 : 4536
        case "ㅃ":
            return 4360
        case "ㅅ":
            return isInitialConsonant ? 4361 : 4538
        case "ㅆ":
            return isInitialConsonant ? 4362 : 4539
        case "ㅇ":
            return isInitialConsonant ? 4363 : 4540
        case "ㅈ":
            return isInitialConsonant ?  4364 : 4541
        case "ㅉ":
            return 4365
        case "ㅊ":
            return isInitialConsonant ?  4366 : 4542
        case "ㅋ":
            return isInitialConsonant ?  4367 : 4543
        case "ㅌ":
            return isInitialConsonant ?  4368 : 4544
        case "ㅍ":
            return isInitialConsonant ?  4369 : 4545
        case "ㅎ":
            return isInitialConsonant ?  4370 : 4546
        default:
            return 0
        }
    }
    
    func toUnicodeVowel() -> Int {
        switch self {
        case "ㅏ":
            return 4449
        case "ㅐ":
            return 4450
        case "ㅑ":
            return 4451
        case "ㅒ":
            return 4452
        case "ㅓ":
            return 4453
        case "ㅔ":
            return 4454
        case "ㅕ":
            return 4455
        case "ㅖ":
            return 4456
        case "ㅗ":
            return 4457
        case "ㅘ":
            return 4458
        case "ㅙ":
            return 4459
        case "ㅚ":
            return 4460
        case "ㅛ":
            return 4461
        case "ㅜ":
            return 4462
        case "ㅝ":
            return 4463
        case "ㅞ":
            return 4464
        case "ㅟ":
            return 4465
        case "ㅠ":
            return 4466
        case "ㅡ":
            return 4467
        case "ㅢ":
            return 4468
        case "ㅣ":
            return 4469
        default:
            return 0
        }
    }
}
