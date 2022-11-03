//
//  SelectMaterialsViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 02/11/22.
//

import UIKit
import RxCocoa
import RxSwift

protocol DidSelectMaterialProtocol: AnyObject {
    func didSelect(type: MaterialsType, quantity: Double)
}

protocol SelectMaterialsProtocol: AnyObject {
    func pushQuantity(type: MaterialsType)
}

class SelectMaterialsViewController: SNViewController<SelectMaterialsStates, SelectMaterialsViewModel> {
    @IBOutlet weak var tableSelectMaterial: UITableView!

    var type: MaterialsType? = nil
    weak var delegate: SelectMaterialsProtocol? = nil

    fileprivate let searchText = PublishSubject<String>()
    private let searchController = UISearchController()
    private var disposeBag = DisposeBag()
    var filtered: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        configureTable()
        viewModel?.didLoad.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
        tableSelectMaterial.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func configureViews() {
    }
    
    override func configureBindings() {
        searchText
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel?.filteredText.onNext(text)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureTable() {
        tableSelectMaterial.register(type: MaterialTableViewCell.self)
        tableSelectMaterial.delegate = self
        tableSelectMaterial.dataSource = self
        
        if #available(iOS 15.0, *) {
            tableSelectMaterial.sectionHeaderTopPadding = 0
        }
    }
    
    override func render(states: SelectMaterialsStates) {
        switch states {
        case .didLoad(let type):
            title = "Adicionar"
            self.type = type
            viewModel?.filteredText.onNext(searchController.searchBar.text ?? "")
        case .filter(let result):
            filtered = result
            tableSelectMaterial.reloadData()
        }
    }
}

extension SelectMaterialsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText.onNext(text)
    }
}

extension SelectMaterialsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = type else { return }
        switch type {
        case .ingredient:
            guard let ingredient = filtered[indexPath.row] as? IngredientsModel, ingredient.firestoreId != nil else { return }
            delegate?.pushQuantity(type: .ingredient(ingredient))
        case .material:
            guard let material = filtered[indexPath.row] as? MaterialModel, material.firestoreId != nil else { return }
            delegate?.pushQuantity(type: .material(material))
        case .taxes:
            guard let taxes = filtered[indexPath.row] as? TaxeModel, taxes.firestoreId != nil else { return }
            delegate?.pushQuantity(type: .taxes(taxes))
        case .consumption:
            guard let consumption = filtered[indexPath.row] as? ConsumptionModel, consumption.firestoreId != nil else { return }
            delegate?.pushQuantity(type: .consumption(consumption))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fallbackCell = UITableViewCell()
        fallbackCell.backgroundView?.backgroundColor = .clear
        guard let type = type else { return fallbackCell }
        let cell: MaterialTableViewCell = tableView.dequeueReusableCell(indexPath)
        
        switch type {
        case .ingredient:
            guard let ingredient = filtered[indexPath.row] as? IngredientsModel else { return UITableViewCell() }
            guard let name = ingredient.name,
                  let quantity = ingredient.quantity,
                  let measurement = ingredient.measurement,
                  let cost = ingredient.cost else { return fallbackCell }
            
            cell.render(title: name,
                        quantity: "\(quantity) \(measurement)",
                        price: Decimal(cost).asMoney())
        case .material:
            guard let material = filtered[indexPath.row] as? MaterialModel else { return UITableViewCell() }
            guard let name = material.name,
                  let quantity = material.quantity,
                  let measurement = material.measurement,
                  let cost = material.cost else { return fallbackCell }
            
            cell.render(title: name,
                        quantity: "\(quantity) \(measurement)",
                        price: Decimal(cost).asMoney())
        case .taxes:
            guard let taxes = filtered[indexPath.row] as? TaxeModel else { return UITableViewCell() }
            guard let name = taxes.name,
                  let description = taxes.taxeDescription,
                  let cost = taxes.cost else { return fallbackCell }
            
            cell.render(title: name,
                        quantity: description,
                        price: cost.asString().percentFormatting())
        case .consumption:
            guard let consumption = filtered[indexPath.row] as? ConsumptionModel else { return UITableViewCell() }
            guard let name = consumption.name,
                  let _consumption = consumption.consumption,
                  let level = consumption.level  else { return fallbackCell }
            
            cell.render(title: name,
                        quantity: _consumption,
                        price: level)
        }
        return cell
    }
}
