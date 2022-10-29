//
//  MaterialDetailedViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 28/10/22.
//

import UIKit

class MaterialDetailedViewController: SNViewController<MaterialDetailedStates, MaterialDetailedViewModel> {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonMore: UIButton!
    @IBOutlet weak var tableDetailed: UITableView!
    weak var delegate: MaterialsProtocol?
    var firestoreId: String? = nil
    var material: MaterialsType? = nil
    var rows: [DetailedDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        viewModel?.didLoad.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureTable() {
        tableDetailed.register(type: ItemTableViewCell.self)
        tableDetailed.delegate = self
        tableDetailed.dataSource = self
        if #available(iOS 15.0, *) {
            tableDetailed.sectionHeaderTopPadding = 5
        }
        buttonMore.menu = makeContextMenu()
        buttonMore.showsMenuAsPrimaryAction = true
    }

    override func render(states: MaterialDetailedStates) {
        switch states {
        case .success(let string):
            break
        case .loading(let bool):
            break
        case .error(let string):
            break
        case .configure(let id, let type):
            firestoreId = id
            material = type
            switch type {
            case .ingredient(let ingredient):
                labelTitle.text = ingredient?.name ?? ""
            case .material(let material):
                labelTitle.text = material?.name ?? ""
            case .taxes(let taxes):
                labelTitle.text = taxes?.name ?? ""
            case .consumption(let consumption):
                labelTitle.text = consumption?.name ?? ""
            }
            labelDescription.text = type.title()
            rows = DetailedDTO.detailed(type: type)
            tableDetailed.reloadData()
        case .deleted:
            delegate?.popToRoot()
        }
    }
}

extension MaterialDetailedViewController: UITableViewDelegate, UITableViewDataSource {
    private func edit() {
        guard let firestoreId = self.firestoreId, let material = self.material else { return }
        delegate?.presentEdit(id: firestoreId, type: material)
    }
    
    private func delete() {
        guard let firestoreId = self.firestoreId, let material = self.material else { return }
        viewModel?.delete(material: material, id: firestoreId)
    }
    
    func makeContextMenu() -> UIMenu {
        let edit = UIAction(title: "Editar...", image: UIImage(systemName: "pencil")) { [weak self] action in
            self?.edit()
        }
        
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
            self?.delete()
        }

        return UIMenu(title: "Configurações", children: [edit, delete])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemTableViewCell = tableView.dequeueReusableCell(indexPath)
        let item = rows[indexPath.row]
        cell.render(title: item.title, value: item.description ?? "")
        return cell
    }
}
