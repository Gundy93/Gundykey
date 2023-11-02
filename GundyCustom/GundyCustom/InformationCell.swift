//
//  InformationCell.swift
//  GundyCustom
//
//  Created by Gundy on 11/2/23.
//

import UIKit

final class InformationCell: UITableViewCell {
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title1)
        
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(containerStackView)
        [titleLabel, descriptionLabel].forEach { label in
            containerStackView.addArrangedSubview(label)
        }
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setDescription(_ text: String) {
        descriptionLabel.text = text
    }
    
    func setDescriptionHidden(_ isHidden: Bool) {
        descriptionLabel.isHidden = isHidden
        contentView.backgroundColor = isHidden ? .systemBackground : .systemGray6
    }
}
