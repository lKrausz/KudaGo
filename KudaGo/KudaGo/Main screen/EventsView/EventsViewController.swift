//
//  EventsViewController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 09.09.2021.
//

import UIKit
import CoreData

class EventsViewController: UIViewController {

    var page = 1
    var pageSize = 20
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

    let placeholderView = EventPlaceholderView(text: "Актуальных событий по выбранным категориям не найдено.")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(tableView)

//        view.addSubview(placeholderView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        fetchData()
    }

    func fetchData() {

        NetworkManager.shared.getEvents(page: self.page, pageSize: self.pageSize, completion: { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            if let data = data {
                self.data += data
                self.page += 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        // TODO: удалить или придумать как сделать шоб работал плейсхолдер
//        if self.data.count == 0 {
//            self.placeholderView.alpha = 1
//        } else {
//            self.placeholderView.alpha = 0
//        }
    }
}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else { preconditionFailure("Cell type not found")}
        let event = EventModel(data: self.data[indexPath.row])
        cell.cellConfig(data: event, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NetworkManager.shared.getEvent(eventId: Int(data[indexPath.row].id), completion: { [weak self] (data, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error)
                }
                if let data = data {
                    let eventData = EventModel(data: data)
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
