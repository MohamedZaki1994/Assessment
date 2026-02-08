//
//  Coordinator.swift
//  Assessment
//

import SwiftUI
import Combine

enum Destination: Hashable {
	case reposHome
	case repoDetails
}

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()

    func append(_ destination: Destination) {
        path.append(destination)
    }

    func pop() {
		path = .init()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
