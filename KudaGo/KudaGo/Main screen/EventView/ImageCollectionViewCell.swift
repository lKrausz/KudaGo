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
    
    func cellConfig(image: Image) {
        backgroundColor = .red
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        downloadImage(from: URL.init(string: image.image)!)
        layer.cornerRadius = 35
        clipsToBounds = true
    }
        
    func downloadImage(from url: URL) {
        NetworkManager.shared.getImage(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
}
