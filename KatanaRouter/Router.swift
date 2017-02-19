//
//  Router.swift
//  KatanaRouter
//
//  Created by Michal Ciurus on 13/02/17.
//  Copyright © 2017 Michal Ciurus. All rights reserved.
//

import Katana

open class Router<State: RoutableState> {
    
    let store: Store<State>
    var lastNavigationStateCopy: NavigationTreeNode?
    let routingQueue: DispatchQueue
    
    public init(store: Store<State>) {
        self.store = store
        routingQueue = DispatchQueue(label: "RoutingQueue", attributes: [])
        _ =  store.addListener { [weak self] in
            self?.stateChanged()
        }
        stateChanged()
    }
    
    private func stateChanged() {
        let currentState = store.state.navigationState.navigationTreeRootNode
        fireActionsForChanges(lastState: lastNavigationStateCopy, currentState: currentState)
        lastNavigationStateCopy = currentState?.deepCopy()
    }
    
    private func fireActionsForChanges(lastState: NavigationTreeNode?, currentState: NavigationTreeNode?) {
        let actions = NavigationTreeDiff.getNavigationDiffActions(lastState: lastState, currentState: currentState)
        
        for action in actions {
            
            let completionSemaphore = DispatchSemaphore(value: 0)
            
            routingQueue.async {
                let completion: RoutableCompletion = {
                    completionSemaphore.signal()
                }
                switch action {
                case .push(let nodeToPush):
                    DispatchQueue.main.async {
                        self.performPush(node: nodeToPush, completion: completion)
                    }
                case .pop(let nodeToPop):
                    DispatchQueue.main.async {
                        self.performPop(node: nodeToPop, completion: completion)
                    }
                case .changed(let x, let y):
                    DispatchQueue.main.async {
                        self.performChange(nodesToPop: x, nodesToPush: y, completion: completion)
                    }
                    
                    let timeToWait = DispatchTime.now() + .seconds(3)
                    let result = completionSemaphore.wait(timeout: timeToWait)
                    
                    if case .timedOut = result {
                        fatalError("The Routable completion handler has not been called. Please make sure that you call the handler in each Routable method")
                    }
                }
            }
        }
    }
    
    private func performPush(node: NavigationTreeNode, completion: @escaping RoutableCompletion) {
        if let parentNode = node.parentNode {
            let routable = parentNode.currentRoutable!.push(destination: node.value, completionHandler: completion)
            node.currentRoutable = routable
        }
    }
    
    private func performPop(node: NavigationTreeNode, completion: @escaping RoutableCompletion) {
        if let parentNode = node.parentNode {
            parentNode.currentRoutable!.pop(destination: node.value, completionHandler: completion)
        }
    }
    
    private func performChange(nodesToPop: [NavigationTreeNode], nodesToPush: [NavigationTreeNode], completion: @escaping RoutableCompletion) {
        let node = nodesToPop.count > 0 ? nodesToPop[0] : nodesToPush[0]
        
        if let parentNode = node.parentNode {
            let destinationsToPop = nodesToPush.map { $0.value }
            let destinationsToPush = nodesToPush.map { $0.value }
            let routables = parentNode.currentRoutable!.change(destinationsToPop: destinationsToPop, destinationsToPush: destinationsToPush, completionHandler: completion)
            
            for nodeToPush in nodesToPush {
                let routable = routables[nodeToPush.value]
                if let routable = routable {
                    nodeToPush.currentRoutable = routable
                } else {
                    fatalError("Did not find a correct Routable for a pushed Destination. Please make sure you're returning a correct dictionary in change(destinationsToPop:destinationsToPush:completionHandler:)")
                }
            }
            
        }
    }
    
}
