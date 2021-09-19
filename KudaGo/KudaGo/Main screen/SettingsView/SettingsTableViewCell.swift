//
//  SettingsTableViewCell.swift
//  KudaGo
//
//  Created by Виктория Козырева on 15.09.2021.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    func cellConfig(setting: String) {
        self.textLabel?.text = setting
        self.accessoryType = .disclosureIndicator
    }

    override var reuseIdentifier: String? {
        return "SettingsTableViewCell"
    }
}
