//
//  TextTableViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 15.09.2021.
//

import UIKit
import SafariServices

class TextTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UITextView = {
        let textView = UITextView()
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isSelectable = true
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override var reuseIdentifier: String? {
        return "TextTableViewCell"
    }
    
    func cellConfig(label: String){
        contentView.addSubview(titleLabel)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        self.titleLabel.text = label
    }

}

extension TextTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        //let controller = SFSafariViewController.init(url: URL)
        //present(controller, animated: true, completion: nil)
        print("go to link with safari")
        return false
    }
}
