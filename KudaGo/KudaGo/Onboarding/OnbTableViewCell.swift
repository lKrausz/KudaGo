//
//  OnbTableViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 22.06.2021.
//

import UIKit

class OnbTableViewCell: UITableViewCell {

    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func cellConfig(labelContent: String?) {
        self.label.text = labelContent
        contentView.addSubview(view)
        view.addSubview(label)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setConstraints()
    }
    
    func setConstraints() {

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            view.heightAnchor.constraint(equalToConstant: 50)

        ])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
    
    override var reuseIdentifier: String? {
        return "OnbTableViewCell"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.alpha = 1
        } else {
            contentView.alpha = 0.75
        }
    }
}
