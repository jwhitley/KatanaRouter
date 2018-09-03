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
extension SelectChild: Action { }
extension AddChildrenToDestination: Action { }
extension SetRootDestination: Action { }

/// Add a new destination on top of the current route
public struct AddNewDestinationCreator<ViewController: AnyObject, Store>: Action {
  public let creator: (Store) -> Destination<ViewController>

  public init(creator: @escaping (Store) -> Destination<ViewController>) {
    self.creator = creator
  }
}

extension Variable: ObservablePropertyType {
  public typealias ValueType = Element
  public typealias DisposeType = DisposableWrapper

  public func subscribe(_ function: @escaping (Element) -> Void) -> DisposableWrapper {
    return DisposableWrapper(disposable: asObservable().subscribe(onNext: function))
  }
}

extension Observable: StreamType {
  public typealias ValueType = Element
  public typealias DisposeType = DisposableWrapper

  public func subscribe(_ function: @escaping (Element) -> Void) -> DisposableWrapper {
    return DisposableWrapper(disposable: subscribe(onNext: function))
  }
}

public struct DisposableWrapper: SubscriptionReferenceType {
  public let disposable: Disposable

  public func dispose() {
    disposable.dispose()
  }
}

extension Store: RouterStore {
  public func dispatch<A: NavigationAction>(_ action: A) {
    dispatch(action as! Action)
  }
}
