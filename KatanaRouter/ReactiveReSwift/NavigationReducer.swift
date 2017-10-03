//
//  NavigationReducer.swift
//  KatanaRouter
//
//  Created by John Whitley on 9/29/17.
//  Copyright © 2017 John Whitley. See LICENSE.md.
//

import ReactiveReSwift

func navigationReducer<ViewController>(action: Action, state: NavigationState<ViewController>) -> NavigationState<ViewController> {
    // NOTE: This is uglier than it might be, primarily because the
    // protocol NavigationAction can't implement updatedState() without
    // associated types, which makes it useless in Swift.
    switch action {
    case let na as AddNewDestination<ViewController>:
      return na.updatedState(currentState: state)
    case let na as RemoveDestination<ViewController>:
      return na.updatedState(currentState: state)
    case let na as RemoveCurrentDestination<ViewController>:
      return na.updatedState(currentState: state)
    case let na as AddChildrenToDestination<ViewController>:
      return na.updatedState(currentState: state)
    case let na as SetRootRoutable<ViewController>:
      return na.updatedState(currentState: state)
    default:
      return state
    }
}
