//
//  EventViewController.swift
//  KudaGo
//
//  Created by Виктория Козырева on 09.09.2021.
//

import UIKit

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
    
    var data: EventFullDesc!
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
        
    init(data: EventFullDesc) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bookmark"), style: .plain, target: self, action: #selector(addBookmark(_:)))
        view.backgroundColor = .white
        view.addSubview(contentTableView)
        setConstraints()
    }
    
    @IBAction func addBookmark(_ sender: Any) {
        print("bookmark")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            cell.cellConfig(label: data.title.uppercased())
            return cell
        
        case .images:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryTableViewCell", for: indexPath) as! GalleryTableViewCell
            cell.cellConfig(data: data.images)
            return cell
        
        case .eventDescription:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            cell.cellConfig(label: data.eventDescription)

            return cell
        
        case .dates:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            
            let dataStart = data.dates.last?.start_date ?? ""
            let dataEnd = data.dates.last?.end_date ?? "Постоянно"
            
            let dateText = "Дата: \(dataStart) - \(dataEnd)"
            cell.cellConfig(label: dateText)
            return cell
        
        case .price:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            cell.cellConfig(label: "Цена: " + data.price)
            return cell
            
        case .place:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            cell.cellConfig(label: "Адрес: " + (data.place?.address ?? "Не указано"))
            return cell
            
        case .url:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            cell.cellConfig(label: "Подробнее: " + data.url)
            return cell
    
        }
        
    }
    
}
