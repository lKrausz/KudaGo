//
//  ImageCollectionViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 14.09.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    override var reuseIdentifier: String? {
        return "ImageCollectionViewCell"
    }

    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()

    func cellConfig(image: String) {
        backgroundColor = .gray
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        NetworkManager.shared.getImage(from: URL.init(string: image)!) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
        layer.cornerRadius = 35
        clipsToBounds = true
    }
}
