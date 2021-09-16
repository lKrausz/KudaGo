//
//  BookMarksViewController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 09.09.2021.
//

import UIKit

class BookMarksViewController: UIViewController {

    //TODO: CoreData
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(EventPlaceholderView())
    }
}
