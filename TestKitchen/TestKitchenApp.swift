//
//  TestKitchenApp.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/1/25.
//

import SwiftUI
import SwiftData

@main
struct TestKitchenApp: App {
  @State var navigationManager = NavigationManager(testID: "homeView")

  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Recipe.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  var body: some Scene {
    WindowGroup {
      GeometryReader { geometry in
        HomeView()
          .environment(\.navigationManager, navigationManager)
          .environment(\.screenSize, geometry.size)
      }
    }
    .modelContainer(sharedModelContainer)
  }
}

extension EnvironmentValues {
  @Entry var screenSize: CGSize = CGSize()
}
