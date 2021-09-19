//
//  BookMarksViewController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 09.09.2021.
//

import UIKit
import CoreData

class BookmarkViewController: UIViewController {

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

        view.backgroundColor = .white

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        DataBaseManager.shared.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTableView()
    }
    
}

extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = DataBaseManager.shared.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else { preconditionFailure("Cell type not found") }
        let event = EventModel(data: DataBaseManager.shared.fetchedResultsController.object(at: indexPath))
        cell.delegate = self
        cell.cellConfig(data: event, indexPath: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = EventModel(data: DataBaseManager.shared.fetchedResultsController.object(at: indexPath))
        let captureViewCon = EventViewController(data: event)
        self.navigationController?.pushViewController(captureViewCon, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionInfo = DataBaseManager.shared.fetchedResultsController.sections![indexPath.section]
        if indexPath.row == (sectionInfo.numberOfObjects - 5) {
            DataBaseManager.shared.loadData()
        }
    }
}

extension BookmarkViewController: EventTableViewCellProtocol {
    func reloadTableView() {
        DataBaseManager.shared.loadData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
