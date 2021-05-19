//
//  RxExtension.swift
//  Arum
//
//  Created by trinhhc on 5/20/21.
//
import RxSwift
import RxCocoa

extension ObservableType {
    public func ignoreFastTap() -> RxSwift.Observable<Self.Element> {
        return self.throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
}

extension Reactive where Base: UIScrollView {
    /// Reactive wrapper for `scrollViewDidScrollToBottom` action
    public var didScrollToBottom: ControlEvent<Bool> {
        let source = contentOffset.map { offset -> Bool in
            let scrollView = self.base as UIScrollView
            let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
            let offsetY = offset.y + scrollView.contentInset.top
            let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
            
            return offsetY > threshold ? true : false
        }
        
        return ControlEvent(events: source)
    }
    
    var currentPage: Observable<Int> {
        return didEndDecelerating.map({
            let pageWidth = self.base.frame.width
            let page = floor((self.base.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            return Int(page)
        })
    }
}

extension Reactive where Base: UIImageView {
    func activeImage(imageActive: UIImage?, imageUnActive: UIImage?) -> Binder<Bool> {
        return Binder(base) { base, active in
            base.image = active ? imageActive : imageUnActive
        }
    }
}
