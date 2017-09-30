//
//  NavigationReducer.swift
//  KatanaRouter
//
//  Created by John Whitley on 9/29/17.
//  Copyright © 2017 John Whitley. See LICENSE.md.
//

import ReactiveReSwift

let navigationReducer: Reducer<NavigationState> = { action, state in
  guard let navigationAction = action as? NavigationAction else {
    return state
  }

  return navigationAction.updatedState(currentState: state)
}
