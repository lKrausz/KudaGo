//
//  EventTableViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 10.09.2021.
//

import UIKit

protocol EventTableViewCellProtocol: AnyObject {
    func reloadTableView()
}
// MARK: Ячейка события
class EventTableViewCell: UITableViewCell {

    var eventId = 0
    var indexPath: IndexPath = []
    weak var delegate: EventTableViewCellProtocol?

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

    lazy var bookmarkButton: BookmarkButton = {
        let button = BookmarkButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addBookmark(sender:)), for: .touchUpInside)
        return button
    }()

    override var reuseIdentifier: String? {
        return "EventTableViewCell"
    }
// MARK: функция для конфигурации ячейки 
    func cellConfig(data: EventModel, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.eventId = Int(data.id)
        let imageURL = data.images[0]
        let imagePath: NSString = imageURL as NSString

        if let cachedImage = NSCacheManager.shared.cache.object(forKey: imagePath) {
            DispatchQueue.main.async { [weak self] in
                self?.eventImage.image = cachedImage
            }
        } else {
            let url = URL(string: imageURL)!
            NetworkManager.shared.getImage(from: url) { data, _, error in
                if error != nil {
                    return
                }
                if let data = data {
                    DispatchQueue.main.async { [weak self] in
                    let image = UIImage(data: data)!
                    self?.eventImage.image = image
                    NSCacheManager.shared.cache.setObject(image, forKey: imagePath)
                    }
                }
            }
        }

        titleLabel.text = data.title
        priceLabel.text = data.price
        dateLabel.text = data.dates

        contentView.addSubview(eventImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dateLabel)
        eventImage.addSubview(bookmarkButton)
        setConstraints()
    }

    @objc func addBookmark(sender: BookmarkButton!) {
        bookmarkButton.changeState()
        if DataBaseManager.shared.isInDataBase(eventID: eventId) {
            DataBaseManager.shared.deleteEvent(index: indexPath)
        } else {
            NetworkManager.shared.getEvent(eventId: Int(eventId), completion: { data, error in
                if error != nil {
                    return
                }
                if let data = data {
                    let eventData = EventModel(data: data)
                    DataBaseManager.shared.addEvent(event: eventData)
                }
            })
        }
        delegate?.reloadTableView()
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            eventImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            eventImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            eventImage.heightAnchor.constraint(equalToConstant: 180)
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
        super.prepareForReuse()
        self.eventImage.image = nil
        self.bookmarkButton.setState(state: false)
    }
}
