//
//  PreviewContainer.swift
//  TestKitchen
//
//  Created by Derek Vallar on 5/1/25.
//

import SwiftUI
import SwiftData

struct PreviewContainer<D: PersistentModel> {
  let modelContainer: ModelContainer

  init() {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    do {
      modelContainer = try ModelContainer(for: D.self, configurations: config)
    } catch {
      fatalError("Could not initialize ModelContainer")
    }
  }

  func addExamples(_ examples: [D]) {
    Task { @MainActor in
      examples.forEach { example in
        modelContainer.mainContext.insert(example)
      }
    }
  }
}
