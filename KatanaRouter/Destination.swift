//
//  Destination.swift
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
open class Destination<ViewController: AnyObject> {
  /// User identifier is optional, but has bigger priority than the instance identifier
  public let userIdentifier: String?
  public let instanceIdentifier: UUID

  /// Create a new ViewController instance
  ///
  private var _create: (UUID) -> ViewController

  public weak var viewController: ViewController? = nil

  public func create() -> ViewController {
    let vc: ViewController = viewController ?? _create(instanceIdentifier)

    viewController = vc

    return vc
  }

  /// Create a router Destination
  ///
  ///   - parameter userIdentifier: identifier set by user to easily manage destinations **must be unique! **
  ///   - parameter instanceIdentifier: unique destination identifier
  ///   - parameter create: A closure that creates the ViewController associated with this Destination instance
  ///
  /// The `create` closure should setup and return the ViewController instance associated with this
  /// `Destination`. Further, it should usually close over the app's Store, and construct the
  /// ViewController using the Store instance.
  ///
  public init(userIdentifier: String? = nil,
              instanceIdentifier: UUID = UUID(),
              create: @escaping (UUID) -> ViewController) {
    self.instanceIdentifier = instanceIdentifier
    self.userIdentifier = userIdentifier
    self._create = create
  }

  /// Singular push action happened
  ///
  /// - Parameters:
  ///   - store: the app store used to build views (or view models)
  ///   - destination: destination to push
  ///   - completionHandler: completion handler **needs to be called** after the transition
  open func push(_ destination: Destination<ViewController>, _ completionHandler: @escaping RoutableCompletion) {
    fatalError("`push` function is not implemented in this Destination")
  }

  /// Singular pop action happened
  ///
  /// - Parameters:
  ///   - destination: destination to pop
  ///   - completionHandler: completion handler **needs to be called** after the transition
  open func pop(_ destination: Destination<ViewController>, _ completionHandler: @escaping RoutableCompletion) {
    fatalError("`pop` function is not implemented in this Destination")
  }


  /// A more complex action. At least two singular pop/push actions.
  /// It gives you a chance to replace the Routables in one smooth transition.
  ///
  /// - Parameters:
  ///   - store: the app store used to build views (or view models)
  ///   - destinationsToPop: destinations to pop
  ///   - destinationsToPush: destinations to push
  ///   - completionHandler: completion handler **needs to be called** after the transition
  /// - Returns: **Important** A set of all pushed Destinations. The Router `fatalError`s if
  ///
  open func change(_ destinationsToPop: [Destination<ViewController>],
                   _ destinationsToPush: [Destination<ViewController>],
                   _ completionHandler: @escaping RoutableCompletion) {
    fatalError("`change` function is not implemented in this Destination")
  }


  /// Called when there's a new destination set to active
  ///
  /// It is optional for Destinations to override this method.
  ///
  /// - Parameters:
  ///   - currentActiveDestination: destination that was set to active
  ///   - completionHandler: completion handler **needs to be called** after the transition
  open func changeActiveDestination(_ currentActiveDestination: Destination<ViewController>,
                                    _ completionHandler: @escaping RoutableCompletion) {
    completionHandler()
  }

  /// Called when the current active child is re-selected
  ///
  /// It is optional for Destinations to override this method.
  ///
  /// - parameter currentActiveDestination: destination that was set to active
  /// - parameter completionHandler: completion handler **needs to be called** after the transition
  open func selectActiveDestination(_ currentActiveDestination: Destination<ViewController>,
                                    _ completionHandler: @escaping RoutableCompletion) {
    completionHandler()
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

extension Destination: CustomStringConvertible {
  public var description: String {
    let typeName = ("\(type(of: self))".split(separator: " ", maxSplits: 1).first!).dropFirst()
    if let userId = self.userIdentifier {
      return "\(typeName)(userId: \(userId), uuid: \(self.instanceIdentifier))"
    } else {
      return "\(typeName)(uuid: \(self.instanceIdentifier))"
    }
  }
}
