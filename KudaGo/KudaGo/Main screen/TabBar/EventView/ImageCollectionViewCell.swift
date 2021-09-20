//
//  ImageCollectionViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 14.09.2021.
//

import UIKit
// MARK: Ячейка для изображения в галерее изображений
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

    func cellConfig(imageURL: String) {
        backgroundColor = .gray
        contentView.addSubview(imageView)

        setConstraints()

        let imagePath: NSString = imageURL as NSString
        if let cachedImage = NSCacheManager.shared.cache.object(forKey: imagePath) {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = cachedImage
            }
        } else {
            let url = URL(string: imageURL)!
            NetworkManager.shared.getImage(from: url) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { [weak self] in
                    let image = UIImage(data: data)!
                    self?.imageView.image = image
                    NSCacheManager.shared.cache.setObject(image, forKey: imagePath)
                }
            }
        }
        layer.cornerRadius = 35
        clipsToBounds = true
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
