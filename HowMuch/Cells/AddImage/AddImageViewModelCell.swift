//
//  AddImageViewModelCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 26/10/22.
//

import Foundation
import RxSwift
import RxCocoa

typealias Base64 = String

class AddImageViewModelCell: CellViewModel {
    weak var output: AddImageOutputProtocol?
    
    var completion: ((_ item: KeyValue?, _ menu: KeyValue?) -> Void)?
    var isValid = BehaviorSubject<Bool>(value: true)
    var image: UIImage? = nil
    var imageBase64: Base64? = nil
    
    private var disposeBag = DisposeBag()
    
    deinit {
        Sanada.print("Deinitializing: \(self)")
        disposeBag = DisposeBag()
        isValid.onCompleted()
    }
    
    init(_ image: UIImage? = nil) {
        self.image = image
        
        let base64Observable = Observable.of(imageBase64)
        
        let imageObservable = Observable.of(image)
        
        Observable.combineLatest(base64Observable, imageObservable)
            .map { !(($0.0?.isEmpty ?? false) && $0.1 == nil) }
            .bind(to: isValid)
            .disposed(by: disposeBag)
    }
    
    @discardableResult
    func reduce(image: Data) -> UIImage? {
        let reducedImage = UIImage(data: image)
        self.image = reducedImage
        return reducedImage
    }
    
    @discardableResult
    func convert(image: Data) -> Base64 {
        let string = image.base64EncodedString(options: .lineLength64Characters)
        imageBase64 = string
        return string
    }
    
    @discardableResult
    func compress(image: UIImage) -> Data {
        let reduced = image.compress(to: 300)
        reduce(image: reduced)
        convert(image: reduced)
        return reduced
    }
}

extension AddImageViewModelCell: AddImageInputProtocol {
    func awake() {
        guard let image = image else { return }
        output?.setImage(image)
    }
    
    func image(_ image: UIImage?) {
        guard let image = image else {
            self.image = nil
            self.imageBase64 = ""
            self.output?.setImage(self.image)
            return
        }
        output?.loadingImage(true)
        compress(image: image)
        output?.loadingImage(false)
        guard let smallImage = self.image else {
            return
        }
        output?.setImage(smallImage)
    }
}

extension AddImageViewModelCell {
    func bind(completion: @escaping ((KeyValue?, KeyValue?) -> Void)) {
        self.completion = completion
    }
    
    func clean() {
        completion = nil
        output?.clean()
    }
    
    func complete() {
        let item: KeyValue? = {
           return KeyValue(key: "image", value: imageBase64)
        }()

        completion?(item, nil)
    }
}
