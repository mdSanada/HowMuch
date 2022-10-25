//
//  SalesCreateViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit

class SalesCreateViewController: UIViewController {
    @IBOutlet weak var createTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
    
    func configureTable() {
        createTable.register(type: TextFieldTableViewCell.self)
        createTable.register(type: AddItemTableViewCell.self)
        createTable.register(type: AddButtonFooterTableViewCell.self)
        createTable.delegate = self
        createTable.dataSource = self
        
//        if #available(iOS 15.0, *) {
//            createTable.sectionHeaderTopPadding = 50
//        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SalesCreateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: TextFieldTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.render(type: indexPath.row == 0 ? .title : .body,
                        title: indexPath.row == 0 ? "Title" : "body",
                        placeholder: indexPath.row == 0 ? "Title" : "body")
            return cell
        case 1, 2:
            if indexPath.row == 3 {
                let cell: AddButtonFooterTableViewCell = tableView.dequeueReusableCell(indexPath)
                cell.render(title: "Adicionar")
                return cell
            }
            let cell: AddItemTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.render(title: "Title", quantity: "5 units", value: 10)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
