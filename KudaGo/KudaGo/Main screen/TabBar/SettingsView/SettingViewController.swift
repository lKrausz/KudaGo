//
//  OnbViewController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 22.06.2021.
//

import UIKit

// MARK: Отвечает за экран вариантов настройки
class SettingViewController: UIViewController {

    var categories: Set<String> = []
    let currentType: SettingsType
    let isOnboarding: Bool

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .white.withAlphaComponent(0.6)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.gray.cgColor
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    init(type: SettingsType, isOnboarding: Bool) {
        self.currentType = type
        self.isOnboarding = isOnboarding
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var data = [OnboardingApiResponse].init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if isOnboarding {
            setBG()
        }
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        setConstraints()
        switch self.currentType {

        case .location:
            titleLabel.text = "О событиях в каком городе вы бы хотели узнавать?"
            NetworkManager.shared.getLocations(completion: { [weak self] data, error in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                }
                if let data = data {
                    self.data = data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })

        case .eventCategories:
            titleLabel.text = "Какие категории событий вы бы хотели видеть в подборке?"
            self.tableView.allowsMultipleSelection = true
            self.tableView.allowsMultipleSelectionDuringEditing = true
            NetworkManager.shared.getEventCategories(completion: { [weak self] data, error in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                }
                if let data = data {
                    self.data = data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
            addReadyButton()
        }
    }

    func setBG() {
        let backgroundImage = UIImageView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: view.bounds.width,
                                                        height: view.bounds.height))
        backgroundImage.image = UIImage(named: "onbBG")
        backgroundImage.clipsToBounds = false
        backgroundImage.alpha = 0.9
        view.addSubview(backgroundImage)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }

    func addReadyButton() {
        self.view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -5)
        ])

    }

    @objc func buttonAction(sender: UIButton!) {
        button.backgroundColor = .systemGray5
        var categoriesString: String = ""
        if !self.categories.isEmpty {
        categoriesString = {
            var string = ""
            for category in self.categories {
                string += category + ","
            }
            string.removeLast()
            return string
        }()
        }
        DataManager.shared.setCategories(categories: categoriesString)
        if isOnboarding {
            DataManager.shared.setIsNewUserStatus()
            UIApplication.shared.windows.first?.rootViewController = TabBarController()
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

// swiftlint:disable line_length

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else { preconditionFailure("Cell type not found") }
        cell.cellConfig(labelContent: self.data[indexPath.row].name, isOnboarding: isOnboarding)
        return cell
    }

// swiftlint:enable line_length

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentType == .location {
            DataManager.shared.setLocation(location: data[indexPath.row].slug)
            if isOnboarding {
                let captureViewCon = SettingViewController(type: .eventCategories, isOnboarding: isOnboarding)
                self.navigationController?.pushViewController(captureViewCon, animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.categories.insert(data[indexPath.row].slug)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if currentType == .eventCategories {
            self.categories.remove(data[indexPath.row].slug)
        }
    }
}
