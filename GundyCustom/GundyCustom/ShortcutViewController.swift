//
//  ShortcutViewController.swift
//  GundyCustom
//
//  Created by Gundy on 10/26/23.
//

import UIKit

final class ShortcutViewController: UIViewController {
    
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
        var shortcut = UIPasteboard(name: UIPasteboard.Name(consonant), create: false)?.string
        
        if shortcut?.isEmpty == true {
            shortcut = nil
        }
        
        if shortcut == nil {
            shortcut = consonant.defaultShortcut
        }
        
        cell.setTitle(consonant)
        cell.setShortcutText(shortcut ?? Constant.labelPlaceHolder)
        
        return cell
    }
}

extension ShortcutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlertController(Constant.consonants[indexPath.row])
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
    
    private func showAlertController(_ text: String) {
        let alertController = UIAlertController(title: Constant.alertTitle + text,
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = Constant.textFieldPlaceHolder
        }
        
        let acceptAction = UIAlertAction(title: "적용",
                                         style: .default) { [weak self] _ in
            guard let newShortcut = alertController.textFields?.first?.text else { return }
            
            if let existBoard = UIPasteboard(name: UIPasteboard.Name(text), create: false) {
                existBoard.string = newShortcut
            } else {
                UIPasteboard(name: UIPasteboard.Name(text), create: true)?.string = newShortcut
            }
            
            self?.shortcutTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel)
        
        [acceptAction, cancelAction].forEach { action in
            alertController.addAction(action)
        }
        present(alertController,
                animated: true)
    }
}

extension ShortcutViewController {
    
    enum Constant {
        
        static let description: String = """
                                         아래의 칸을 눌러 특정 문구를 해당하는 자음에 단축키로 설정할 수 있습니다.
                                         
                                         설정한 단축키는 해당 키를 0.5초간 누르면 입력됩니다.
                                         
                                         'ㅃ'부터 'ㅅ'까지는 미설정 시 '1'부터 '0'까지의 숫자가 기본값으로 입력됩니다.
                                         """
        static let consonants: [String] = ["ㅃ", "ㅉ", "ㄸ", "ㄲ", "ㅆ", "ㅂ", "ㅈ", "ㄷ", "ㄱ", "ㅅ", "ㅁ", "ㄴ", "ㅇ", "ㄹ", "ㅎ", "ㅋ", "ㅌ", "ㅊ", "ㅍ"]
        static let labelPlaceHolder: String = "지정된 단축키가 없습니다."
        static let alertTitle: String = "단축키 "
        static let textFieldPlaceHolder: String = "단축키를 작성하세요."
    }
}
