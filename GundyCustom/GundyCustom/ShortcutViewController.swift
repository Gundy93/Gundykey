//
//  ShortcutViewController.swift
//  GundyCustom
//
//  Created by Gundy on 10/26/23.
//

import UIKit

final class ShortcutViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    private let contentStackView: UIStackView = {
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
    private let shortcutTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(ShortcutCell.self,
                           forCellReuseIdentifier: "ShortcutCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(contentStackView)
        [descriptionLabel, shortcutTableView].forEach { subView in
            contentStackView.addArrangedSubview(subView)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            contentStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureTableView() {
        shortcutTableView.dataSource = self
        shortcutTableView.delegate = self
    }
}

extension ShortcutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.consonants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShortcutCell",
                                                       for: indexPath) as? ShortcutCell else { return ShortcutCell() }
        let consonant = Constant.consonants[indexPath.row]
        
        cell.setTitle(consonant)
        cell.setShortcutText(UserDefaults.standard.string(forKey: consonant) ?? Constant.placeHolder)
        
        return cell
    }
}

extension ShortcutViewController: UITableViewDelegate {}

extension ShortcutViewController {
    
    enum Constant {
        
        static let description: String = "아래의 칸을 눌러 특정 문구를 해당하는 자음에 단축키로 설정할 수 있습니다."
        static let consonants: [String] = ["ㅃ", "ㅉ", "ㄸ", "ㄲ", "ㅆ", "ㅂ", "ㅈ", "ㄷ", "ㄱ", "ㅅ", "ㅁ", "ㄴ", "ㅇ", "ㄹ", "ㅎ", "ㅋ", "ㅌ", "ㅊ", "ㅍ"]
        static let placeHolder: String = "지정된 단축키가 없습니다."
    }
}
