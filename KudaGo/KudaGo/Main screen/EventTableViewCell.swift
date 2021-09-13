//
//  EventTableViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 10.09.2021.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 30
        view.backgroundColor = .gray
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Some title"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Some price"
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date start - Date end"
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.init(named: "bookmarkButton"), for: .normal)
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        return button
    }()

    override var reuseIdentifier: String? {
        return "EventTableViewCell"
    }
    // add content: EventsApiResponse when add network logic
    func cellConfig() {
        contentView.addSubview(bgImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dateLabel)
        bgImageView.addSubview(bookmarkButton)
        
        setConstraints()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("tapped")
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bgImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bgImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bgImageView.heightAnchor.constraint(equalToConstant: 180),
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bgImageView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            bookmarkButton.topAnchor.constraint(equalTo: bgImageView.topAnchor, constant: 8),
            bookmarkButton.trailingAnchor.constraint(equalTo: bgImageView.trailingAnchor, constant: -8),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 40),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
