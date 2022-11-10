//
//  AddImageTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class AddImageTableViewCell: UITableViewCell {
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageCamera: UIImageView!
    
    private var disposeBag = DisposeBag()
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    private var camera: CameraHandler? = nil
    
    var parentController: UIViewController?
    var viewModel: AddImageViewModelCell!
    
    deinit {
        disposeBag = DisposeBag()
        camera = nil
        parentController = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingIndicator.hidesWhenStopped = true
        configure()
        camera = CameraHandler()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func bind(viewModel: AddImageViewModelCell) {
        self.viewModel = viewModel
        self.viewModel?.output = self
        self.viewModel?.awake()
    }
    
    func configure() {
        imageBackground.rx
            .tapGesture()
            .when(.recognized)
            .withLatestFrom(isLoadingSubject)
            .filter { !$0 }
            .subscribe(onNext: { [weak self] _ in
                self?.requestImage()
            })
            .disposed(by: disposeBag)
        
        isLoadingSubject
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func requestImage() {
        guard let controller = parentController else { return }
        camera?.showActionSheet(controller: controller,
                                completion: imageAction)
    }
    
    internal func imageAction(_ image: UIImage?) {
        viewModel.image(image)
    }
}

extension AddImageTableViewCell: AddImageOutputProtocol {
    func clean() {
        camera = nil
        parentController = nil
        isLoadingSubject.onCompleted()
    }
    
    func loadingImage(_ loading: Bool) {
        isLoadingSubject.onNext(loading)
        imageCamera.isHidden = loading
    }
    
    func setImage(_ image: UIImage?) {
        imageBackground.image = image
    }
}
