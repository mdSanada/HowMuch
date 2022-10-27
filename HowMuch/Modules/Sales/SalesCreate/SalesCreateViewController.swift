//
//  SalesCreateViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit

class SalesCreateViewController: UIViewController {
    @IBOutlet weak var createTable: UITableView!
    var itens: [CreateDTO] = CreateDTO.sales()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
    
    func configureTable() {
        createTable.register(type: TextFieldTableViewCell.self)
        createTable.register(type: AddItemTableViewCell.self)
        createTable.register(type: AddButtonFooterTableViewCell.self)
        createTable.register(type: AddImageTableViewCell.self)
        createTable.delegate = self
        createTable.dataSource = self
    }
    
    private func create() {
        
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SalesCreateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens[section].itens.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = itens[section]
        return item.showTitle ? item.section : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itens[indexPath.section]
        let row = item.itens[indexPath.row]
        
        switch row {
        case .image:
            let cell: AddImageTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.render(image: nil)
            return cell
        case .text(let viewModel):
            let cell: TextFieldTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.bind(viewModel: viewModel)
            return cell
        case .item(let model):
            guard let type = model?.itemType else { return UITableViewCell() }
            switch type {
            case .item:
                // Passar componente pelo o item
                let cell: AddItemTableViewCell = tableView.dequeueReusableCell(indexPath)
                cell.render(title: "Title", quantity: "5 units", value: 10)
                return cell
            case .add:
                let cell: AddButtonFooterTableViewCell = tableView.dequeueReusableCell(indexPath)
                cell.render(title: "Adicionar")
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}
