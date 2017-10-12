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
  let root: Destination<ViewController>

  let children: [Destination<ViewController>]

  let activeDestination: Destination<ViewController>

  public func updatedState(_ currentState: NavigationState<ViewController>) -> NavigationState<ViewController> {
    var state = currentState
    let rootNode = NavigationTreeNode(value: root, isActiveRoute: true)
    let childNodes = children.map { addDestination -> NavigationTreeNode<ViewController> in
      return NavigationTreeNode(value: addDestination, isActiveRoute: addDestination == activeDestination)
    }
    rootNode.addChildren(childNodes)

    state.setNavigationTreeRootNode(rootNode)
    return state
  }
}
