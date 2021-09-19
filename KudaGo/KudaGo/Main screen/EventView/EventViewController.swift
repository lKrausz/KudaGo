//
//  EventViewController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 09.09.2021.
//

import UIKit
import SafariServices

enum CellContentType: Int {
    case title = 0
    case images
    case eventDescription
    case dates
    case price
    case place
    case url
}

class EventViewController: UIViewController {

    var data: EventModel
    let tableContent: [CellContentType] = [.title, .images, .eventDescription, .dates, .price, .place, .url]

    lazy var contentTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GalleryTableViewCell.self, forCellReuseIdentifier: "GalleryTableViewCell")
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "TextTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()

    init(data: EventModel) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark_empty"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addBookmark(_:)))
        view.backgroundColor = .white
        view.addSubview(contentTableView)
        setConstraints()
    }

    @IBAction private func addBookmark(_ sender: Any) {
        if (!DataBaseManager.shared.isInDataBase(eventID: Int(data.id))) {
            NetworkManager.shared.getEvent(eventId: Int(data.id), completion: { data, error in
                if let error = error {
                    print(error)
                }
                if let data = data {
                    let eventData = EventModel(data: data)
                    DataBaseManager.shared.addElement(element: eventData)
                }
            })
        }
    }

    func setConstraints() {

        NSLayoutConstraint.activate([
            contentTableView.topAnchor.constraint(equalTo: view.topAnchor),
            contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type: CellContentType = CellContentType(rawValue: indexPath.row)!

        switch type {
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as? TextTableViewCell else { preconditionFailure("Cell type not found")}
            cell.cellConfig(label: data.title)
            return cell

        case .images:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryTableViewCell", for: indexPath) as? GalleryTableViewCell else { preconditionFailure("Cell type not found") }
            cell.cellConfig(data: data.images)
            return cell

        case .eventDescription:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as? TextTableViewCell else { preconditionFailure("Cell type not found")}
            cell.delegate = self
            cell.cellConfig(label: data.eventDescription!)

            return cell
        case .dates:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as? TextTableViewCell else { preconditionFailure("Cell type not found")}

            cell.cellConfig(label: data.dates)
            return cell

        case .price:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as? TextTableViewCell else { preconditionFailure("Cell type not found")}
            cell.cellConfig(label: data.price)
            return cell

        case .place:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as? TextTableViewCell else { preconditionFailure("Cell type not found")}
            cell.cellConfig(label: data.place!)
            return cell

        case .url:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as? TextTableViewCell else { preconditionFailure("Cell type not found")}
            cell.delegate = self
            cell.cellConfig(label: data.url!)
            return cell
        }
    }
}

extension EventViewController: TextTableViewCellDelegate {

    func goToLink(url: URL, sender: TextTableViewCell) {
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true, completion: nil)
    }
}
