//
//  EventsViewController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 09.09.2021.
//

import UIKit

class EventsViewController: UIViewController {
    
    var page = 1
    var page_size = 20
    var data = [Event].init()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        fetchData()
    }
    
    func fetchData() {
        NetworkManager.shared.getEvents(page: self.page, page_size: self.page_size, completion: { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            if let data = data {
                self.data = self.data + data
                self.page += 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        cell.cellConfig(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkManager.shared.getEvent(id: Int(data[indexPath.row].id), completion: { [weak self] (data, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                }
                if let data = data {
                    let eventData = data
                    DispatchQueue.main.async {
                        let captureViewCon = EventViewController(data: eventData)
                        self.navigationController?.pushViewController(captureViewCon, animated: true)
                    }

                }
            })
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (data.count - 5) {
            fetchData()
        }
    }
    
}

