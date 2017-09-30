//
//  ReactiveReSwiftBridge.swift
//  gemioios
//
//  Created by John Whitley on 9/15/17.
//  Copyright © 2017 John Whitley. See LICENSE.md.
//

import ReactiveReSwift
import RxSwift

extension AddNewDestination: Action { }
extension RemoveDestination: Action { }
extension RemoveCurrentDestination: Action { }
extension AddChildrenToDestination: Action { }
extension SetRootDestination: Action { }
extension SetRootRoutable: Action { }

extension Variable: ObservablePropertyType {
  public typealias ValueType = Element
  public typealias DisposeType = DisposableWrapper

  public func subscribe(_ function: @escaping (Element) -> Void) -> DisposableWrapper? {
    return DisposableWrapper(disposable: asObservable().subscribe(onNext: function))
  }
}

extension Observable: StreamType {
  public typealias ValueType = Element
  public typealias DisposeType = DisposableWrapper

  public func subscribe(_ function: @escaping (Element) -> Void) -> DisposableWrapper? {
    return DisposableWrapper(disposable: subscribe(onNext: function))
  }
}

public struct DisposableWrapper: SubscriptionReferenceType {
  let disposable: Disposable

  public func dispose() {
    disposable.dispose()
  }
}
