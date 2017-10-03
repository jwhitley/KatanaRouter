//
//  NavigationActions.swift
//  KatanaRouter
//
//  Created by Michal Ciurus on 09/02/17.
//  Copyright © 2017 Michal Ciurus. All rights reserved.
//

import Foundation

/**
 A marker protocol for navigation actions.

 This marker protocol represents navigation actions.  Because it would require associated types, it
 can't actually require the `updatedState` function in its interface.

 As such, each class that implements `NavigationAction` must implement `updatedState()` and be handled
 separately in `navigationReducer`.
 */
public protocol NavigationAction {
//  func updatedState(currentState: NavigationState<ViewController>) -> NavigationState<ViewController>
}

/// Add a new destination on top of the current route
public struct AddNewDestination<ViewController: Routable>: NavigationAction {
  
  private let destination: Destination<ViewController>
  
  public init(destination: Destination<ViewController>) {
    self.destination = destination
  }
  
  public func updatedState(currentState: NavigationState<ViewController>) -> NavigationState<ViewController> {
    var state = currentState
    state.addNewDestinationToActiveRoute(destination: destination)
    return state
  }
}

/// Removes the destination with given instance identifier from the navigation tree
/// Doesn't do anything if the node is not in the tree
/// Very useful for updating the tree with automatic navigation e.g. back button in UINavigationController
public struct RemoveDestination<ViewController: Routable>: NavigationAction {
  
  private let instanceIdentifier: UUID
  
  
  public init(instanceIdentifier: UUID) {
    self.instanceIdentifier = instanceIdentifier
  }
  
  public func updatedState(currentState: NavigationState<ViewController>) -> NavigationState<ViewController> {
    var state = currentState
    state.removeDestination(instanceIdentifier: instanceIdentifier)
    return state
  }
}

/// Removes currently active destination
public struct RemoveCurrentDestination<ViewController: Routable>: NavigationAction {
  public func updatedState(currentState: NavigationState<ViewController>) -> NavigationState<ViewController> {
    var state = currentState
    state.removeDestinationAtActiveRoute()
    return state
  }
  
  public init() {
    
  }
}

// Add children to a node with given user identifier
public struct AddChildrenToDestination<ViewController: Routable>: NavigationAction {
  
  private let destinationIdentifier: String
  // All destinations to add
  private let destinations: [Destination<ViewController>]
  // Destination to set active as
  private let activeDestination: Destination<ViewController>?
  
  public init(identifier: String,
              destinations: [Destination<ViewController>],
              activeDestination: Destination<ViewController>?) {
    self.destinationIdentifier = identifier
    self.destinations = destinations
    self.activeDestination = activeDestination
  }
  
  
  /// Adds one active child to a destination
  ///
  /// - Parameters:
  ///   - identifier: destination to add to
  ///   - child: to add to the destination
  public init(identifier: String, child: Destination<ViewController>) {
    self.destinationIdentifier = identifier
    self.destinations = [child]
    self.activeDestination = child
  }
  
  public func updatedState(currentState: NavigationState<ViewController>) -> NavigationState<ViewController> {
    var state = currentState
    guard let node = state.mutateNavigationTreeRootNode()?.find(userIdentifier: destinationIdentifier) else {
      return currentState
    }
    
    let childrenNodes = destinations.map { addDestination -> NavigationTreeNode<ViewController> in
      return NavigationTreeNode(value: addDestination, isActiveRoute: addDestination == activeDestination)
    }
    
    node.addChildren(childrenNodes)
    
    return state
  }
}
