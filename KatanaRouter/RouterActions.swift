//
//  RouterActions.swift
//  KatanaRouter
//
//  Created by John Whitley on 9/29/17.
//  Copyright © 2017 John Whitley. See LICENSE.md.
//

/// This action is a trigger for the NavigationMiddleware that updates the router's root routable,
/// and emits SetRootDestination, above.
///
public struct SetRootDestination<ViewController: AnyObject>: NavigationAction {
  // The router to use in the state
  //
  // This must be of type Router<Store, ViewController>, but the type system fallout from
  // using that generic type here is ... extreme.
  let router: Any

  /// root destination to be set
  let destination: Destination<ViewController>

  public func updatedState(_ currentState: NavigationState<ViewController>) -> NavigationState<ViewController> {
    var state = currentState
    let rootNode = NavigationTreeNode(value: destination, isActiveRoute: true)
    state.setNavigationTreeRootNode(rootNode)
    return state
  }
}
