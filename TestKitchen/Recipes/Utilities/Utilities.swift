//
//  Utilities.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/4/25.
//

import SwiftUI

protocol Discussable {
  
}



//protocol CommunityView {
//  associatedtype T: View
//  var view: T { get }
//}

//extension CommunityView {
//  /// Navigate to a new view.
//  /// - Parameters:
//  ///   - newView: View to navigate to.
//  ///   - binding: Only navigates when this condition is `true`.
//  func navigate(to newView: T, when binding: Binding<Bool>) -> some View {
//    NavigationView {
//      ZStack {
//        view
//          .navigationBarTitle("")
//          .navigationBarHidden(true)
//          .navigationD
//        
//        NavigationLink(
//          destination: newView
//            .navigationBarTitle("")
//            .navigationBarHidden(true),
//          isActive: binding
//        ) {
//          EmptyView()
//        }
////        NavigationLink(destination: <#T##() -> Destination#>, label: <#T##() -> Label#>)
//      }
//    }
//    .navigationViewStyle(.stack)
//  }
//}
