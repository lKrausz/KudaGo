//
//  EventTableViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 10.09.2021.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    lazy var eventImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage.init(named: "bookmark"), for: .normal)
        button.addTarget(self, action: #selector(addBookmark(sender:)), for: .touchUpInside)
        return button
    }()

    override var reuseIdentifier: String? {
        return "EventTableViewCell"
    }

    func cellConfig(data: Event) {
        let url = URL(string:data.images[0].image)!
        NetworkManager.shared.getImage(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.eventImage.image = UIImage(data: data)
            }
        }
        titleLabel.text = data.title.uppercased()
        priceLabel.text = "Цена: " + {
            if data.price == "" {
                return "Бесплатно" }
            else {
                return data.price
            }
        }()
        //TODO: Придумать как собирать нужные даты из Апи / забить и отправлять на сайт для подробной информации
        let dataStart = data.dates.last?.start_date ?? ""
        let dataEnd = data.dates.last?.end_date ?? "Постоянно"
        
        dateLabel.text = "Дата: \(dataStart) - \(dataEnd)"
        contentView.addSubview(eventImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dateLabel)
        eventImage.addSubview(bookmarkButton)
        
        setConstraints()
    }
    
    @objc func addBookmark(sender: UIButton!) {
        //TODO: add bookmark logic & animation
        print("tapped")
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            eventImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            eventImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            eventImage.heightAnchor.constraint(equalToConstant: 180),
        ])

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: eventImage.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
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
            bookmarkButton.topAnchor.constraint(equalTo: eventImage.topAnchor, constant: 8),
            bookmarkButton.trailingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: -8),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 40),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func prepareForReuse() {
        self.eventImage.image = nil
        priceLabel.text = nil
        titleLabel.text = nil
        dateLabel.text = nil
    }
    
}
