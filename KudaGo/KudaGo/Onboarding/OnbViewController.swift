//
//  OnbViewController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 22.06.2021.
//

import UIKit

class OnbViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OnbTableViewCell.self, forCellReuseIdentifier: "OnbTableViewCell")
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

    var data = [OnboardingApiResponse].init()
    var currentType: OnboardingType = OnboardingPresentor.shared.currentOnboardScreen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        backgroundImage.image = UIImage.init(named: "onbBG")
        backgroundImage.clipsToBounds = false
        backgroundImage.alpha = 0.9
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        navigationController?.navigationBar.prefersLargeTitles = true

        setConstraints()
        
        
        
        switch self.currentType {
        
        case .location:
            titleLabel.text = "О событиях в каком городе вы бы хотели узнавать?"
            NetworkManager.shared.getLocations(completion: { [weak self] (data, error) in
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
            
        case .event:
            titleLabel.text = "Какие события наиболее интересны для вас?"
            self.tableView.allowsMultipleSelection = true
            self.tableView.allowsMultipleSelectionDuringEditing = true
            NetworkManager.shared.getEventCategories(completion: { [weak self] (data, error) in
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
            button.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -5)
        ])
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        //TODO: save events data, add animations, set value in userdefaults
        UIApplication.shared.windows.first?.rootViewController = TapBarController()
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}

extension OnbViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnbTableViewCell", for: indexPath) as! OnbTableViewCell
        cell.cellConfig(labelContent: self.data[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentType == .location {
        OnboardingPresentor.shared.currentOnboardScreen = .event
        let captureViewCon = OnbViewController()
        self.navigationController?.pushViewController(captureViewCon, animated: true)
        //TODO: save location
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    
}
