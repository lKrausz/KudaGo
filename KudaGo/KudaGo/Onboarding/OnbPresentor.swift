//
//  OnbPresentor.swift
//  KudaGo
//
//  Created by Виктория Козырева on 22.06.2021.
//

import Foundation

enum OnboardingType {
    case location
    case event
}

class OnboardingPresentor {
    static var shared = OnboardingPresentor()
    var currentOnboardScreen: OnboardingType = .location

}
