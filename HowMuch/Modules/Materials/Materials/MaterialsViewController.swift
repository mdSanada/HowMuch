//
//  MaterialsViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class MaterialsViewController: SNViewController<MaterialsStates, MaterialsViewModel> {
    @IBOutlet weak var tableMaterials: UITableView!
    let segmentItems = MaterialsType.allCases.map { $0.title() }
    var segmentMaterials: UISegmentedControl?
    
    weak var delegate: MaterialsProtocol?
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
        tableMaterials.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func configureViews() {
        segmentMaterials = UISegmentedControl(items: segmentItems)
        segmentMaterials?.selectedSegmentIndex = 0
        segmentMaterials?.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
    }
        
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        Vibration.light.vibrate()
        let index = segmentedControl.selectedSegmentIndex
        let stringType = segmentItems[index]
        title = stringType
        viewModel?.choosedSubject.onNext(segmentItems[index])
        viewModel?.filteredText.onNext(searchController.searchBar.text ?? "")
        tableMaterials.reloadData()
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
        tableMaterials.register(type: MaterialTableViewCell.self)
        tableMaterials.delegate = self
        tableMaterials.dataSource = self
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        tableMaterials.addGestureRecognizer(longPressRecognizer)
        
        if #available(iOS 15.0, *) {
            tableMaterials.sectionHeaderTopPadding = 0
        }
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        guard let index = segmentMaterials?.selectedSegmentIndex else { return }
        let stringType = segmentItems[index]
        guard let material = MaterialsType.fromTitle(stringType) else { return }
        Vibration.light.vibrate()
        delegate?.create(type: material)
    }
    
    override func render(states: MaterialsStates) {
        switch states {
        case .didLoad:
            let stringType = segmentItems[0]
            title = stringType
            viewModel?.choosedSubject.onNext(segmentItems[0])
            viewModel?.filteredText.onNext(searchController.searchBar.text ?? "")
        case .filter(let result):
            filtered = result
            tableMaterials.reloadData()
        }
    }
}

extension MaterialsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText.onNext(text)
    }
}

extension MaterialsViewController: UITableViewDataSource, UITableViewDelegate {
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: tableMaterials)
            if let indexPath = tableMaterials.indexPathForRow(at: touchPoint) {
                guard let index = segmentMaterials?.selectedSegmentIndex else { return }
                let stringType = segmentItems[index]
                guard let material = MaterialsType.fromTitle(stringType) else { return }
                switch material {
                case .ingredient:
                    guard let ingredient = filtered[indexPath.row] as? IngredientsModel,
                          let firestoreId = ingredient.firestoreId else { return }
                    delegate?.presentEdit(id: firestoreId, type: .ingredient(ingredient))
                case .material:
                    guard let material = filtered[indexPath.row] as? MaterialModel,
                          let firestoreId = material.firestoreId else { return }
                    delegate?.presentEdit(id: firestoreId, type: .material(material))
                case .taxes:
                    guard let taxes = filtered[indexPath.row] as? TaxeModel,
                          let firestoreId = taxes.firestoreId else { return }
                    delegate?.presentEdit(id: firestoreId, type: .taxes(taxes))
                case .consumption:
                    guard let consumption = filtered[indexPath.row] as? ConsumptionModel,
                          let firestoreId = consumption.firestoreId else { return }
                    delegate?.presentEdit(id: firestoreId, type: .consumption(consumption))
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let index = segmentMaterials?.selectedSegmentIndex else { return }
        let stringType = segmentItems[index]
        guard let material = MaterialsType.fromTitle(stringType) else { return }
        switch material {
        case .ingredient:
            guard let ingredient = filtered[indexPath.row] as? IngredientsModel, let firestoreId = ingredient.firestoreId else { return }
            delegate?.pushDetailed(id: firestoreId, type: .ingredient(ingredient))
        case .material:
            guard let material = filtered[indexPath.row] as? MaterialModel, let firestoreId = material.firestoreId else { return }
            delegate?.pushDetailed(id: firestoreId, type: .material(material))
        case .taxes:
            guard let taxes = filtered[indexPath.row] as? TaxeModel, let firestoreId = taxes.firestoreId else { return }
            delegate?.pushDetailed(id: firestoreId, type: .taxes(taxes))
        case .consumption:
            guard let consumption = filtered[indexPath.row] as? ConsumptionModel, let firestoreId = consumption.firestoreId else { return }
            delegate?.pushDetailed(id: firestoreId, type: .consumption(consumption))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let segmentMaterials = segmentMaterials else { return nil }
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(segmentMaterials)
        segmentMaterials.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.leading.trailing.greaterThanOrEqualToSuperview().priority(.low)
            make.top.bottom.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(31)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fallbackCell = UITableViewCell()
        fallbackCell.backgroundView?.backgroundColor = .clear
        guard let segmentMaterials = segmentMaterials,
              let segmentTitle = segmentMaterials.titleForSegment(at: segmentMaterials.selectedSegmentIndex),
              let type = MaterialsType.fromTitle(segmentTitle)
        else { return fallbackCell }
        
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
