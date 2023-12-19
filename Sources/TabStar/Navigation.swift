//
//  Navigation.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-12-19.
//

import SwiftUI

final class Navigation: ObservableObject {
    /// Return `true` to indicate that an auxiliary action was performed.
    typealias AuxiliaryAction = () -> Bool
    
    var pathActions: [Int: (dismiss: DismissAction?, auxiliaryAction: AuxiliaryAction?)] = [:]
    
    /// Navigation always performs dismiss action (if available), but may choose to perform an auxiliary action first.
    ///
    /// This action includes support for popping back to sidebar view in a `NavigationSplitView`.
    var dismiss: DismissAction?
    /// An auxiliary action may consist of multiple sub-actions: To do so, simply configure this action to return false once all sub-actions have been (or can no longer be) performed.
    ///
    /// - Warning: Navigation may skip this action, depending on user preference or other factors. Do not perform critical logic in this action.
    var auxiliaryAction: AuxiliaryAction?
}

// MARK: - Primary Action
extension Navigation {
    
    enum PrimaryAction {
        case dismiss
    }
}

// MARK: - Navigation Behaviour
extension Navigation {
    
    enum Behaviour {
        /// Mimics Apple platforms tab bar navigation behaviour (i.e. pop to root regardless of navigation stack size, then scroll to top).
        case system
        /// Only perform the primary action for navigation (this defaults to dismiss action).
        case primary
        /// Perform the auxiliary action(s) first, if specified, before proceeding with the primary action.
        case primaryAuxiliary
    }
}
