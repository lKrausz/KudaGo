//
//  BookmarkButton.swift
//  KudaGo
//
//  Created by Виктория Козырева on 19.09.2021.
//

import UIKit

class BookmarkButton: UIButton {
    private var isSaved = false

    private let unsavedImage = UIImage(named: "bookmark_empty")
    private let savedImage = UIImage(named: "bookmark_filled")

    private let unsavedScale: CGFloat = 0.7
    private let savedScale: CGFloat = 1.3

    override public init(frame: CGRect) {
        super.init(frame: frame)

        setImage(unsavedImage, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func changeState() {
        isSaved = !isSaved
        animate()
    }

    public func setState(state: Bool) {
        isSaved = state
        animate()
    }

    private func animate() {
        UIView.animate(withDuration: 0.1, animations: {
            let newImage = self.isSaved ? self.savedImage : self.unsavedImage
            let newScale = self.isSaved ? self.savedScale : self.unsavedScale
            self.transform = self.transform.scaledBy(x: newScale, y: newScale)
            self.setImage(newImage, for: .normal)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
