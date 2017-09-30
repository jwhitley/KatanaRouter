//
//  RouterActions.swift
//  KatanaRouter
//
//  Created by John Whitley on 9/29/17.
//  Copyright © 2017 John Whitley. See LICENSE.md.
//

public struct SetRootDestination: NavigationAction {
  let rootDestination: Destination

  public func updatedState(currentState: NavigationState) -> NavigationState {
    var state = currentState
    let rootNode = NavigationTreeNode(value: rootDestination, isActiveRoute: true)
    state.setNavigationTreeRootNode(rootNode)
    return state
  }
}

/// This action is a trigger for the NavigationMiddleware that updates the router's root routable,
/// and emits SetRootDestination, above.
///
public struct SetRootRoutable: NavigationAction {
  /// router to set the root of
  let router: Router
  /// root routable to be set
  let routable: Routable
  /// if new root is created, this identifier will used
  let identifier: String?

  public func updatedState(currentState: NavigationState) -> NavigationState {
    return currentState
  }
}
