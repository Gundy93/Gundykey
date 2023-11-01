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
        
        cell.textLabel?.text = Constant.allCases[indexPath.row].itemDescription
        cell.imageView?.image = UIImage(systemName: Constant.allCases[indexPath.row].imageName)
        cell.tintColor = .label
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = Constant.allCases[indexPath.row].itemDescription
        var nextViewController: UIViewController = UIViewController()
        
        switch title {
        case Constant.practice.itemDescription:
            nextViewController = PracticeViewController()
        case Constant.shortcut.itemDescription:
            nextViewController = ShortcutViewController()
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
        
        static let mainTitle: String = "건디 키보드"
        
        case practice
        case shortcut
        
        var itemDescription: String {
            switch self {
            case .practice:
                return "키보드 추가하기"
            case .shortcut:
                return "단축키 지정하기"
            }
        }
        var imageName: String {
            switch self {
            case .practice:
                return "keyboard"
            case .shortcut:
                return "rectangle.and.hand.point.up.left"
            }
        }
    }
}
