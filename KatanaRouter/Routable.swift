//
//  Routbale.swift
//  KatanaRouter
//
//  Created by Michal Ciurus on 15/02/17.
//  Copyright © 2017 MichalCiurus. All rights reserved.
//

import Foundation

public typealias RoutableCompletion = () -> Void

/// Building block of KatanaRouter
/// Represents a unique navigation destination
/// Every destination has a unique instanceIdentifier
/// Optionally, it can have a userIdentifier, which has higher priority than instanceIdentifier
/// ** userIdentifier ** must be unique!!
public struct Destination<ViewController: Routable> {
  /// User identifier is optional, but has bigger priority than the instance identifier
  public let userIdentifier: String?
  public let instanceIdentifier: UUID

  /// Create a new ViewController instance
  ///
  /// This closure should setup and return a new ViewController instance.
  /// Further, it should usually close over the app's Store, and
  /// construct the ViewController using the Store instance.
  public var create: () -> ViewController

  /// - Parameters:
  ///   - routableType: routable type of the destination
  ///   - contextData: context data e.g. flags, animation properties
  ///   - userIdentifier: identifier set by user to easily manage destinations **must be unique! **
  ///   - instanceIdentifier: unique destination identifier
  public init(userIdentifier: String? = nil, instanceIdentifier: UUID = UUID(), create: @escaping () -> ViewController) {
    self.instanceIdentifier = instanceIdentifier
    self.userIdentifier = userIdentifier
    self.create = create
  }
}

extension Destination: Equatable, Hashable {
  public var hashValue: Int {
    return instanceIdentifier.hashValue
  }

  public static func ==(lhs: Destination, rhs: Destination) -> Bool {
    if let lhsUserIdentifier = lhs.userIdentifier,
      let rhsUserIdentifier = rhs.userIdentifier {
      return lhsUserIdentifier == rhsUserIdentifier
    } else {
      return lhs.instanceIdentifier == rhs.instanceIdentifier
    }
  }
}

public protocol Routable {
  associatedtype ViewController

  /// Singular push action happened
  ///
  /// - Parameters:
  ///   - store: the app store used to build views (or view models)
  ///   - destination: destination to push
  ///   - completionHandler: completion handler **needs to be called** after the transition
  /// - Returns: the Routable responsible for the pushed object
  func push(destination: Destination<ViewController>,
            completionHandler: @escaping RoutableCompletion) -> Routable


  /// Singular pop action happened
  ///
  /// - Parameters:
  ///   - destination: destination to pop
  ///   - completionHandler: completion handler **needs to be called** after the transition
  func pop(destination: Destination<ViewController>,
           completionHandler: @escaping RoutableCompletion)


  /// A more complex action. At least two singular pop/push actions.
  /// It gives you a chance to replace the Routables in one smooth transition.
  ///
  /// - Parameters:
  ///   - store: the app store used to build views (or view models)
  ///   - destinationsToPop: destinations to pop
  ///   - destinationsToPush: destinations to push
  ///   - completionHandler: completion handler **needs to be called** after the transition
  /// - Returns: **Important** A dictionary of pushed destinations and their corresponding Routables
  ///            You need to return all the created Routables for the pushed destinations
  func change(store: Store,
              destinationsToPop: [Destination<ViewController>],
              destinationsToPush: [Destination<ViewController>],
              completionHandler: @escaping RoutableCompletion) -> [Destination<ViewController> : Routable]


  /// Called when there's a new destination set to active
  ///
  /// - Parameters:
  ///   - currentActiveDestination: destination that was set to active
  ///   - completionHandler: completion handler **needs to be called** after the transition
  func changeActiveDestination(currentActiveDestination: Destination<ViewController>,
                               completionHandler: @escaping RoutableCompletion)
}

public extension Routable {

  // push, pop, change need to be implemented *if* they're ever called. Otherwise the UI navigation tree and the Router navigation tree will be out of sync which is an invalid state and the application should not be allowed to run.

  func push(destination: Destination<ViewController>,
            completionHandler: @escaping RoutableCompletion) -> Routable {
    fatalError("`push` function is not implemented in this Routable")
  }

  func pop(destination: Destination<ViewController>, completionHandler: @escaping RoutableCompletion) {
    fatalError("`pop` function is not implemented in this Routable")
  }

  func change(destinationsToPop: [Destination<ViewController>],
              destinationsToPush: [Destination<ViewController>],
              completionHandler: @escaping RoutableCompletion) -> [Destination<ViewController> : Routable] {
    fatalError("`change` function is not implemented in this Routable")
  }

  // changeActiveDestination is fully optional

  func changeActiveDestination(currentActiveDestination: Destination<ViewController>,
                               completionHandler: @escaping RoutableCompletion) {
    completionHandler()
  }
}

