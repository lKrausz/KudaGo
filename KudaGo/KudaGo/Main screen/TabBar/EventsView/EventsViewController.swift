//
//  EventsViewController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 09.09.2021.
//

import UIKit
import CoreData
// MARK: Отвечает за экран событий
class EventsViewController: UIViewController {

    var page = 1
    var pageSize = 20
    var isGetAllRequestData = false
    var data = [EventShortDescription].init()

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
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData),
                                               name: Notification.Name("SettingsUpdate"),
                                               object: nil)
        showAlert()

        view.addSubview(tableView)

        view.addSubview(placeholderView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @objc func reloadData() {
        self.page = 1
        self.isGetAllRequestData = false
        self.data.removeAll()
        showAlert()
        fetchData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func fetchData() {
            NetworkManager.shared.getEvents(page: self.page, pageSize: self.pageSize, completion: {
                [weak self] data, error in
                guard let self = self else { return }
                    if error != nil {
                        return
                    }
                    if let data = data {
                        self.data += data
                        self.page += 1
                        if self.data.count == data.count {
                            self.isGetAllRequestData = true
                        }
                        DispatchQueue.main.async {
                            self.dismiss(animated: false, completion: nil)
                            self.tableView.reloadData()
                        }
            }
        })
    }

    func showAlert() {
        let alert = UIAlertController(title: nil, message: "Загрузка...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.isEmpty {
            placeholderView.isHidden = false
        } else {
            placeholderView.isHidden = true
        }
        return data.count
    }

// swiftlint:disable line_length

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else { preconditionFailure("Cell type not found") }
        let event = EventModel(data: self.data[indexPath.row])
        cell.cellConfig(data: event, indexPath: indexPath)
        return cell
    }

// swiftlint:enable line_length

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventID = Int(data[indexPath.row].eventId)
        NetworkManager.shared.getEvent(eventId: eventID, completion: { [weak self] data, error in
            guard let self = self else { return }
            if error != nil {
                return
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
        guard let currentCell = cell as? EventTableViewCell else { preconditionFailure("Cell type not found") }
        let eventID = Int(data[indexPath.row].eventId)
        currentCell.bookmarkButton.setState(state: DataBaseManager.shared.isInDataBase(eventID: eventID))
        if indexPath.row == (data.count - 5) && !isGetAllRequestData {
            fetchData()
        }
    }
}
