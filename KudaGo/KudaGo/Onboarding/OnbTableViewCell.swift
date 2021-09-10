//
//  OnbTableViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 22.06.2021.
//

import UIKit

class OnbTableViewCell: UITableViewCell {

    var label = UILabel.init()
    var view = UIView.init()
    
    func cellConfig(labelContent: String?) {
        contentView.addSubview(view)
        view.addSubview(label)
        setConstraints()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 3.0
        view.layer.borderColor = UIColor.black.cgColor
        view.clipsToBounds = true
        
        self.label.text = labelContent
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
    }
    
    func setConstraints() {

        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            view.heightAnchor.constraint(equalToConstant: 40)

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
}
