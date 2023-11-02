//
//  KeyboardSettingViewController.swift
//  GundyCustom
//
//  Created by Gundy on 10/26/23.
//

import UIKit

final class KeyboardSettingViewController: UIViewController {
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let keyboardAdditionLabel: UILabel = {
        let label = UILabel()
        
        label.text = Constant.keyboardAddition
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        
        return label
    }()
    private let keyboardAdditionPathLabel: UILabel = {
        let label = UILabel()
        
        label.text = Constant.keyboardAdditionPath
        label.textColor = .systemBlue
        label.numberOfLines = 0
        
        return label
    }()
    private let shortcutSettingLabel: UILabel = {
        let label = UILabel()
        
        label.text = Constant.shortcutSetting
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        
        return label
    }()
    private let shortcutSettingPathLabel: UILabel = {
        let label = UILabel()
        
        label.text = Constant.shortcutSettingPath
        label.textColor = .systemBlue
        label.numberOfLines = 0
        
        return label
    }()
    private let jumpingButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constant.jumpingTitle,
                        for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureButton()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(containerStackView)
        [keyboardAdditionLabel, keyboardAdditionPathLabel, shortcutSettingLabel, shortcutSettingPathLabel, jumpingButton].forEach { subView in
            containerStackView.addArrangedSubview(subView)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor, constant: -8),
            containerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            containerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureButton() {
        jumpingButton.addTarget(self,
                                action: #selector(jumpToSetting),
                                for: .touchUpInside)
    }
    
    @objc
    private func jumpToSetting() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }
}

extension KeyboardSettingViewController {
    
    enum Constant {
        
        static let keyboardAddition: String = "키보드 추가"
        static let keyboardAdditionPath: String = "설정 > 일반 > 키보드 > 키보드 > 새로운 키보드 추가 > 타사 키보드의 건디 키보드를 선택합니다."
        static let shortcutSetting: String = "단축키 기능 사용"
        static let shortcutSettingPath: String = "설정 > 일반 > 키보드 > 키보드 > 건디 키보드 > 전체 접근 허용을 합니다."
        static let jumpingTitle: String = "설정으로 이동하기"
    }
}
