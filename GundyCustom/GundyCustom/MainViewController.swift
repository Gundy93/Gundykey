//
//  MainViewController.swift
//  GundyCustom
//
//  Created by Gundy on 2023/10/15.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let itemTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "TableViewCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationTitle()
        configureUI()
        configureTableView()
    }
    
    private func configureNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constant.mainTitle
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func configureUI() {
        view.addSubview(itemTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            itemTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            itemTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            itemTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            itemTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
        ])
    }
    
    private func configureTableView() {
        itemTableView.dataSource = self
        itemTableView.delegate = self
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                 for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        
        configuration.text = Constant.allCases[indexPath.row].itemDescription
        configuration.image = UIImage(systemName: Constant.allCases[indexPath.row].imageName)
        cell.contentConfiguration = configuration
        cell.tintColor = .label
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = Constant.allCases[indexPath.row].itemDescription
        var nextViewController: UIViewController = UIViewController()
        
        switch title {
        case Constant.keyboardSetting.itemDescription:
            nextViewController = KeyboardSettingViewController()
        case Constant.information.itemDescription:
            nextViewController = InformationViewController()
        case Constant.shortcut.itemDescription:
            nextViewController = ShortcutViewController()
        case Constant.practice.itemDescription:
            nextViewController = PracticeViewController()
        default:
            break
        }
        
        nextViewController.navigationItem.title = Constant.allCases[indexPath.row].itemDescription
        navigationController?.pushViewController(nextViewController,
                                                 animated: true)
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
}

extension MainViewController {
    
    enum Constant: CaseIterable {
        
        static let mainTitle: String = "건디키"
        
        case keyboardSetting
        case information
        case shortcut
        case practice
        
        var itemDescription: String {
            switch self {
            case .keyboardSetting:
                return "키보드 설정"
            case .information:
                return "모음 입력 방법"
            case .shortcut:
                return "자음 단축키 지정"
            case .practice:
                return "키보드 써 보기"
            }
        }
        var imageName: String {
            switch self {
            case .keyboardSetting:
                return "square.grid.3x1.folder.badge.plus"
            case .information:
                return "info.square"
            case .shortcut:
                return "rectangle.and.hand.point.up.left"
            case .practice:
                return "keyboard"
            }
        }
    }
}
