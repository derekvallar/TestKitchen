//
//  ImageUploadView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 5/6/25.
//

import PhotosUI
import SwiftUI

struct ImageUploadList: View {
  let size: CGFloat

  @State var photoItems: [PhotosPickerItem] = []
  @State var uploadedImages: [Image] = []

  init(size: CGFloat) {
    self.size = size
  }

  var body: some View {
    GeometryReader { geometry in
      ScrollView(.horizontal) {
        HStack {
          ForEach(0..<uploadedImages.count, id: \.self) { index in
            uploadedImages[index]
              .resizable()
              .scaledToFill()
              .frame(width: size, height: size)
              .cornerRadius(4)
          }
          ImageUploadView(
            size: size,
            photoItems: $photoItems,
            uploadedImages: $uploadedImages
          )
        }
      }
      .scrollIndicators(.hidden)
    }
  }
}

struct ImageUploadView: View {

  let size: CGFloat
  @Binding var photoItems: [PhotosPickerItem]
  @Binding var uploadedImages: [Image]
  @State var presentPhotoPicker: Bool = false

  init(size: CGFloat, photoItems: Binding<Array<PhotosPickerItem>>, uploadedImages: Binding<Array<Image>>) {
    self.size = size
    self._photoItems = photoItems
    self._uploadedImages = uploadedImages
  }

  var body: some View {
    ZStack {
      Rectangle()
        .foregroundStyle(Color.TKFontGray)
        .frame(width: size, height: size)
        .overlay() {
          Image(systemName: "plus")
        }
    }

    .frame(width: size, height: size)
    .cornerRadius(4)
    //    .clipped()
    .onTapGesture {
      presentPhotoPicker = true
    }
    .photosPicker(isPresented: $presentPhotoPicker, selection: $photoItems)

    .onChange(of: photoItems) {
      Task {
        uploadedImages.removeAll()

        for item in photoItems {
          if let image = try? await item.loadTransferable(type: Image.self) {
            uploadedImages.append(image)
          }
        }
      }
    }
  }
}
