//
//  MaterialsViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class MaterialsViewController: UIViewController {
    @IBOutlet weak var tableMaterials: UITableView!
    let segmentItems = MaterialsType.allCases.map { $0.title() }
    var segmentMaterials: UISegmentedControl?
    
    weak var delegate: MaterialsProtocol?
    fileprivate let searchText = PublishSubject<String>()
    private let searchController = UISearchController()
    private var disposeBag = DisposeBag()
    var materials: [MaterialModel] = MaterialModel.mock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        configureBindings()
        configureTable()
    }
    
    private func configureViews() {
        segmentMaterials = UISegmentedControl(items: segmentItems)
        segmentMaterials?.selectedSegmentIndex = 0
        segmentMaterials?.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        let index = segmentedControl.selectedSegmentIndex
        let stringType = segmentItems[index]
        guard let material = MaterialsType.fromTitle(stringType) else { return }
        
        switch material {
        case .ingredient:
            break
        case .material:
            break
        case .taxes:
            break
        case .consumption:
            break
        }
        
        tableMaterials.reloadData()
    }

    private func configureBindings() {
        searchText
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.filter(text: text)
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
    
    private func filter(text: String) {
        if text.isEmpty {
            print("Will not filter")
        } else {
            print("Will filter: \(text)")
        }
    }
    @IBAction func actionAdd(_ sender: Any) {
        guard let index = segmentMaterials?.selectedSegmentIndex else { return }
        let stringType = segmentItems[index]
        guard let material = MaterialsType.fromTitle(stringType) else { return }
        delegate?.create(type: material)
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
                let material = materials[indexPath.row]
                delegate?.pushEdit(id: "id", type: .material(material))
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materials.count
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
        let cell: MaterialTableViewCell = tableView.dequeueReusableCell(indexPath)
        let material = materials[indexPath.row]
        guard let name = material.name,
                let quantity = material.quantity,
                let measurement = material.measurement,
                let cost = material.cost else { return UITableViewCell() }

        cell.render(title: name,
                    quantity: "\(quantity) \(measurement)",
                    price: Decimal(cost))
        
        return cell
    }
}
