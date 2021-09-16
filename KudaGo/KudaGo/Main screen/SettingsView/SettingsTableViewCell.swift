//
//  SettingsTableViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 15.09.2021.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    func cellConfig(text: String) {
        self.textLabel?.text = text
    }

    override var reuseIdentifier: String? {
        return "SettingsTableViewCell"
    }
}
