//
//  OnbViewController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 22.06.2021.
//

import UIKit

class OnbViewController: UIViewController {
    
    var tableView = UITableView.init(frame: .zero, style: .plain)
    var titleLabel = UILabel.init(frame: .zero)
    var data = [OnboardingApiResponse].init()
    var currentType: OnboardingType = OnboardingPresentor.shared.currentOnboardScreen
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        titleLabel.textColor = UIColor.label
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 60)])
        
        loadViewIfNeeded()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
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
        
        tableView.register(OnbTableViewCell.self, forCellReuseIdentifier: "OnbTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
    }
    
    func addReadyButton() {
        //TODO: normal button position and constraints
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.setTitle("Ready!", for: .normal)
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
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
    
}
