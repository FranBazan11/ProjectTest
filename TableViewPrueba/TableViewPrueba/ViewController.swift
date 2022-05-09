//
//  ViewController.swift
//  TableViewPrueba
//
//  Created by francisco bazan on 10/19/20.
//  Copyright © 2020 Juan Francisco Bazán Carrizo. All rights reserved.
//


import UIKit

// MARK:- HEADER
class CustomTableViewHeader: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .orange
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- FOOTER
class CustomTableViewFooter: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .green
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- CELL
class CustomTableCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - MarketplaceSection Struct
struct MarketplaceSection {
    let type: String
    let pinned: Bool
}

// MARK: - VIEW CONTROLLER
class ViewController: UIViewController {

    let tableView = UITableView(frame: .zero, style: .plain)
    
    private let headerId = "headerId"
    private let footerId = "footerId"
    private let cellId = "cellId"
    
    var size: CGSize? = nil
    
    var allSections: [MarketPlaceTableViewSection] = []

    let label = UILabel()
    var backend = [MarketplaceSection(type: "main_slider", pinned: false), MarketplaceSection(type: "main_actions", pinned: false),
                   MarketplaceSection(type: "carousel filters y mucho mas texto que venimos poniendo para hacerlo hiper largo y para que toma autolayout", pinned: false), MarketplaceSection(type: "carousel", pinned: false), MarketplaceSection(type: "carousel", pinned: false),
                   MarketplaceSection(type: "filters", pinned: true),
                   MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false),
                   MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false),
                   MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false),
                   MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false),
                   MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false),
                   MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false),
                   MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false),
                   MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false), MarketplaceSection(type: "row", pinned: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        setupTableView()
        
        allSections = backend.mapSectionListToIternalSection()
    }
    
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .lightGray
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        tableView.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: cellId)
        
        
//        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
//        button.backgroundColor = .green
//        button.setTitle("Test Button", for: .normal)
////        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
//
//        self.tableView.addSubview(button)
    }
}

struct MarketPlaceTableViewSection {
    var header: MarketplaceSection?
    var items: [MarketplaceSection]
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSections[section].items.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return allSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        print("Soy la section \(indexPath.section) y la row \(indexPath.row) y este es mi texto \(allSections[indexPath.section].items[indexPath.row].type)")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = allSections[indexPath.section].items[indexPath.row].type
        
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    
    //MARK: - HEADER DELEGATE
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 0
//        }
        let size = label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return allSections.isEmpty ? 0 : allSections[section].header == nil ? 0 : UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                // delete the item here
               
//                if (indexPath.section == 0) {
                    tableView.beginUpdates()
                    self.allSections[indexPath.section].items.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                    tableView.endUpdates()
//                }
                
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let title = sectionTable[section].title else { return nil }
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! CustomTableViewHeader
//        header.textLabel?.numberOfLines = 0
//        header.textLabel?.text = title
//        return header
        
       
//        if #available(iOS 10.0, *) {
//            label.adjustsFontForContentSizeCategory = true
//        } else {
//            NotificationCenter.default.addObserver(self, selector: #selector(contentSizeDidChange(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
//        }
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Here's to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They're not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. About the only thing you can't do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do."
        size = label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return label
    }
    // Still need to do this manually for iOS 9
//       @objc private func contentSizeDidChange(_ notification: NSNotification) {
//           label.font = UIFont.preferredFont(forTextStyle: .title3)
//       }
    
    //MARK: - CELL DELEGATE
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.contentSize.height
//    }
}
