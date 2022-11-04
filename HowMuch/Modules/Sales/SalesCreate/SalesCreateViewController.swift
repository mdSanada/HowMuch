//
//  SalesCreateViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 24/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class SalesCreateViewController: SNViewController<SalesCreateStates, SalesCreateViewModel> {
    @IBOutlet weak var createTable: UITableView!
    @IBOutlet weak var buttonComplete: UIButton!
    
    weak var delegate: MyReceiptProtocol? = nil
    var itens: [CreateDTO] = []
    var flow: MaterialsFlow?
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        title = "Adicionar"
        viewModel?.flow.onNext(flow)
    }
    
    override func configureViews() {
        view.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    func configureTable() {
        createTable.register(type: TextFieldTableViewCell.self)
        createTable.register(type: AddItemTableViewCell.self)
        createTable.register(type: AddButtonFooterTableViewCell.self)
        createTable.register(type: AddImageTableViewCell.self)
        createTable.delegate = self
        createTable.dataSource = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        didDisappear()
        viewModel?.clean()
    }
    
    private func didDisappear() {
        itens = []
    }
    
    override func render(states: SalesCreateStates) {
        switch states {
        case .success(let string):
            Sanada.print(string)
            self.dismiss(animated: true, completion: nil)
        case .loading(let bool):
            break
        case .error(let string):
            Sanada.print(string)
            self.dismiss(animated: true, completion: nil)
        case .button(let enabled):
            buttonComplete.isEnabled = enabled
        case .configure(let itens):
            self.itens = itens
            createTable.reloadData()
        case .reload(new: let itens, section: let section):
            self.itens = itens
            createTable.reloadData()
            createTable.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }

    @IBAction func actionSave(_ sender: Any) {
        view.endEditing(true)
        viewModel?.complete()
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
            viewModel.completion = self.viewModel?.completion
            cell.bind(viewModel: viewModel)
            return cell
        case .item(let viewModel):
            guard let type = viewModel.type else { return UITableViewCell() }
            switch type {
            case .item:
                let cell: AddItemTableViewCell = tableView.dequeueReusableCell(indexPath)
                viewModel.completion = self.viewModel?.completion
                cell.bind(viewModel: viewModel,
                          index: (section: indexPath.section, row: indexPath.row))
                cell.delegate = self
                return cell
            case .add:
                let type = MaterialsType.fromSection(item.section)
                let cell: AddButtonFooterTableViewCell = tableView.dequeueReusableCell(indexPath)
                cell.render(title: viewModel.title ?? "Adicionar") { [weak self] in
                    guard let type = type else { return }
                    self?.delegate?.pushSelectMaterial(type: type)
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}

extension SalesCreateViewController: DidSelectMaterialProtocol {
    func didSelect(type: MaterialsType, quantity: Double) {
        viewModel?.addItem.onNext((type: type, quantity: quantity))
    }
}

extension SalesCreateViewController: DidExcludeItemProtocol {
    func exclude(section: Int, row: Int) {
        viewModel?.removeItem.onNext((section: section, row: row))
    }
}
