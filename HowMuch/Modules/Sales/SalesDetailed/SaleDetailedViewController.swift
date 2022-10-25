//
//  SaleDetailedViewController.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 20/10/22.
//

import UIKit
import ParallaxHeader
import RxCocoa
import RxSwift

class SaleDetailedViewController: UIViewController {
    @IBOutlet weak var tableDetailed: ParallaxGroupedSectionHeaderTableView!
    var headerView: UIView?
    let publishSection = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTable()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let headerView = headerView else { return }
        self.tableDetailed.bringSubviewToFront(headerView)
    }
    
    
    private func configureView() {
    }
    
    private func configureTable() {
        tableDetailed.register(type: ItemTableViewCell.self)
        tableDetailed.delegate = self
        tableDetailed.dataSource = self
        if #available(iOS 15.0, *) {
            tableDetailed.sectionHeaderTopPadding = 5
        }
        
        headerView = createParallaxHeader(image: UIImage(named: "brigadeiro"),
                                          title: "Brigadeiro",
                                          description: "Chocolate Belga")
        
        tableDetailed.parallaxHeader.view = headerView ?? UIView()
        tableDetailed.parallaxHeader.height = 200
        tableDetailed.parallaxHeader.mode = .fill
        tableDetailed.parallaxHeader.minimumHeight = 100
        self.tableDetailed.bringSubviewToFront(headerView!)
    }
    
    private func createParallaxHeader(image: UIImage?, title: String, description: String) -> UIView {
        let textColor = UIColor.white
        let view = UIView()
        view.contentMode = .scaleAspectFill
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFill

        let stack = UIStackView()
        stack.axis = .vertical
        
        let labelTitle = UILabel()
        labelTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        labelTitle.textColor = textColor
        labelTitle.numberOfLines = 2
        labelTitle.text = title
        
        let labelDescription = UILabel()
        labelDescription.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        labelDescription.numberOfLines = 3
        labelDescription.adjustsFontSizeToFitWidth = true
        labelDescription.textColor = textColor
        labelDescription.text = description

        stack.addArrangedSubview(labelTitle)
        stack.addArrangedSubview(labelDescription)
        
        view.addSubview(imageView)
        view.addSubview(stack)
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        stack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        return view
    }
}

extension SaleDetailedViewController: UITableViewDelegate, UITableViewDataSource {
    func makeContextMenu() -> UIMenu {
        let edit = UIAction(title: "Editar...", image: UIImage(systemName: "pencil")) { action in
            print("edit")
        }
        
        let delete = UIAction(title: "Delete Photo", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            print("delete")
        }

        return UIMenu(title: "Configurações", children: [edit, delete])
    }

    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        guard let cell: ItemTableViewCell = tableDetailed.cellForRow(at: indexPath) as? ItemTableViewCell else {
            return nil
        }
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = UIColor.clear
        parameters.visiblePath = UIBezierPath(roundedRect: cell.bounds , cornerRadius: 10.0)
        var targetedPreview: UITargetedPreview? = nil
        targetedPreview = UITargetedPreview(view: cell, parameters: parameters)
        return targetedPreview
    }

    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.makeTargetedPreview(for: configuration)
    }

    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.makeTargetedPreview(for: configuration)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: indexPath as NSCopying,
                                                       previewProvider: nil,
                                                       actionProvider: { suggestedActions in
            return self.makeContextMenu()
        })
        return configuration
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 20 : 18
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemTableViewCell = tableView.dequeueReusableCell(indexPath)
        cell.render(title: "Teste", value: "Valor")
        return cell
    }
}
