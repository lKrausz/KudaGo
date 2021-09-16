//
//  ImageTableViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 15.09.2021.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {
    
    var data = [Image].init()

    lazy var galeryCollectionView: UICollectionView = {
        let layout = CenterCellCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    func cellConfig(data: [Image]) {
        self.data = data
        
        contentView.addSubview(galeryCollectionView)
        
        NSLayoutConstraint.activate([
            galeryCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            galeryCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            galeryCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            galeryCollectionView.heightAnchor.constraint(equalToConstant: 200),
            galeryCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        if let flowLayout = galeryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    override var reuseIdentifier: String? {
        return "GalleryTableViewCell"
    }

}

extension GalleryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.cellConfig(image: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.width - 40
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 50, left: 20, bottom: 50, right: 20)
    }
}
