//
//  SensoryFeedback.swift
//  TabStar
//
//  Created by Bosco Ho on 2023-12-22.
//

import SwiftUI

public extension View {
    
    /// - Parameter playSensoryFeedback: Play the desired haptic feedback for the given trigger.  Only called on systems where `View.sensoryFeedback(...)` is not supported.
    @ViewBuilder
    func _sensoryFeedback<T>(
        _ feedback: _SensoryFeedback?,
        trigger: T,
        playSensoryFeedback: (() -> Void)? = nil
    ) -> some View where T: Equatable {
        if #available(iOS 17.0, *) {
            if let feedback {
                self.sensoryFeedback(feedback.value(), trigger: trigger)
            } else {
                self
            }
        } else {
            if let playSensoryFeedback {
                self.onChange(of: trigger) { _ in
                    playSensoryFeedback()
                }
            } else {
                self
            }
        }
    }
}

// MARK: -
public enum _SensoryFeedback {
    case success
    case warning
    case error
    case selection
    case increase
    case decrease
    case start
    case stop
    case alignment
    case levelChange
    case impact
    case impactWeighted(weight: Weight = .medium, intensity: Double = 1.0)
    case impactFlexible(flexibility: Flexibility, intensity: Double = 1.0)
    
    public enum Weight {
        case light
        case medium
        case heavy
        
        @available(iOS 17.0, *)
        public func value() -> SensoryFeedback.Weight {
            switch self {
            case .light:
                return .light
            case .medium:
                return .medium
            case .heavy:
                return .heavy
            }
        }
    }
    
    public enum Flexibility {
        case rigid
        case solid
        case soft
        
        @available(iOS 17.0, *)
        public func value() -> SensoryFeedback.Flexibility {
            switch self {
            case .rigid:
                return .rigid
            case .solid:
                return .solid
            case .soft:
                return .soft
            }
        }
    }
    
    @available(iOS 17.0, *)
    public func value() -> SensoryFeedback {
        switch self {
        case .success:
            return .success
        case .warning:
            return .warning
        case .error:
            return .error
        case .selection:
            return .selection
        case .increase:
            return .increase
        case .decrease:
            return .decrease
        case .start:
            return .start
        case .stop:
            return .stop
        case .alignment:
            return .alignment
        case .levelChange:
            return .levelChange
        case .impact:
            return .impact
        case .impactWeighted(let weight, let intensity):
            return .impact(weight: weight.value(), intensity: intensity)
        case .impactFlexible(let flexibility, let intensity):
            return .impact(flexibility: flexibility.value(), intensity: intensity)
        }
    }
}
