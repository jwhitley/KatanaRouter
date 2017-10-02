//
//  NavigationMiddleware.swift
//  KatanaRouter
//
//  Created by John Whitley on 9/29/17.
//  Copyright © 2017 Michal Ciurus. All rights reserved.
//

import ReactiveReSwift

public protocol RoutableState {
  var navigationState: NavigationState { get set }
}

public class NavigationMiddleware<State: RoutableState> {
  var router: Router!

  public var middleware: Middleware<State> {
    return Middleware(navMiddleware, routerMiddleware)
  }

  private var navMiddleware: Middleware<State>  {
    return Middleware<State>().sideEffect { getState, dispatch, action in
      guard let setRootAction = action as? SetRootRoutable else {
        return
      }

      if self.router == nil {
        self.router = setRootAction.router
      }

      if let action = self.router.setupRootForRoutable(state: getState(),
                                       routable: setRootAction.routable,
                                       identifier: setRootAction.identifier) {
        dispatch(action)
      }
    }
  }

  private var routerMiddleware: Middleware<State> {
    return Middleware<State>().sideEffect { getState, _, _ in
      self.router.stateChanged(getState())
    }
  }
}
