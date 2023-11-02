//
//  InformationViewController.swift
//  GundyCustom
//
//  Created by Gundy on 11/2/23.
//

import UIKit

final class InformationViewController: UIViewController {
    
    private var isClicked: [Bool] = Array(repeating: true,
                                        count: Constant.vowels.count)
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = Constant.description
        label.numberOfLines = 0
        
        return label
    }()
    private let vowelTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(InformationCell.self,
                           forCellReuseIdentifier: "InformationCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(containerStackView)
        [descriptionLabel, vowelTableView].forEach { subView in
            containerStackView.addArrangedSubview(subView)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            containerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            containerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureTableView() {
        vowelTableView.dataSource = self
        vowelTableView.delegate = self
    }
}

extension InformationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.vowels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell",
                                                       for: indexPath) as? InformationCell else { return InformationCell() }
        let vowel = Constant.vowels[indexPath.row]
        let description = Constant.descriptions[indexPath.row]
        let isHidden = isClicked[indexPath.row]
        
        cell.setTitle(vowel)
        cell.setDescription(description)
        cell.setDescriptionHidden(isHidden)
        
        return cell
    }
}

extension InformationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isClicked[indexPath.row].toggle()
        tableView.reloadRows(at: [indexPath],
                             with: .automatic)
    }
}

extension InformationViewController {
    
    enum Constant {
        
        static let description: String = "모든 모음은 모음 버튼을 누른 후 슬라이드하여 입력합니다."
        static let vowels: [String] = ["ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"]
        static let descriptions: [String] = ["""
                                             오른쪽으로 슬라이드합니다.
                                             →
                                             """,
                                             """
                                             'ㅏ'의 상태에서 되돌아옵니다.
                                             → + ←
                                             """,
                                             """
                                             'ㅐ'의 상태에서 다시 오른쪽으로 슬라이드합니다.
                                             → + ← + →
                                             """,
                                             """
                                             'ㅑ'의 상태에서 다시 되돌아옵니다.
                                             → + ← + → + ←
                                             """,
                                             """
                                             왼쪽으로 슬라이드합니다.
                                             ←
                                             """,
                                             """
                                             'ㅓ'의 상태에서 되돌아옵니다.
                                             ← + →
                                             """,
                                             """
                                             'ㅔ'의 상태에서 다시 오른쪽으로 슬라이드합니다.
                                             ← + → + ←
                                             """,
                                             """
                                             'ㅕ'의 상태에서 다시 되돌아옵니다.
                                             ← + → + ← + →
                                             """,
                                             """
                                             위쪽으로 슬라이드합니다.
                                             ↑
                                             """,
                                             """
                                             'ㅗ'의 상태에서 오른쪽으로 슬라이드합니다.
                                             ↑ + →
                                             """,
                                             """
                                             'ㅘ'의 상태에서 되돌아옵니다.
                                             ↑ + → + ← or ↑ + → + ↙
                                             """,
                                             """
                                             'ㅗ'의 상태에서 되돌아옵니다.
                                             ↑ + ↓
                                             """,
                                             """
                                             'ㅚ'의 상태에서 다시 위쪽으로 슬라이드합니다.
                                             ↑ + ↓ + ↑
                                             """,
                                             """
                                             아래쪽으로 슬라이드합니다.
                                             ↓
                                             """,
                                             """
                                             'ㅜ'의 상태에서 왼쪽으로 슬라이드합니다.
                                             ↓ + ←
                                             """,
                                             """
                                             'ㅝ'의 상태에서 되돌아옵니다.
                                             ↓ + ← + → or ↓ + ← + ↗
                                             """,
                                             """
                                             'ㅜ'의 상태에서 되돌아옵니다.
                                             ↓ + ↑
                                             """,
                                             """
                                             'ㅟ'의 상태에서 다시 아래쪽으로 슬라이드합니다.
                                             ↓ + ↑ + ↓
                                             """,
                                             """
                                             대각선 아래쪽으로 슬라이드합니다.
                                             ↙ or ↘
                                             """,
                                             """
                                             '-'의 상태에서 되돌아옵니다.
                                             ↙ + ↗ or ↘ + ↖
                                             """,
                                             """
                                             대각선 위쪽으로 슬라이드합니다.
                                             ↖ or ↗ 
                                             """]
    }
}
