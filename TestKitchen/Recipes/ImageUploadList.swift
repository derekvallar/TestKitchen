//
//  ImageUploadView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 5/6/25.
//

import PhotosUI
import SwiftUI

struct ImageUploadList: View {
  static let imageSpacing: CGFloat = 10
//  @State var imageSize: CGFloat = 120

  @State var photoItems: [PhotosPickerItem] = []
  @State var uploadedImages: [Image] = []

  var body: some View {
    GeometryReader { geometry in
      let imageSize = ImageUploadList.calculateImageSize(from: geometry.size.width)
      ScrollView(.horizontal) {
        HStack(spacing: ImageUploadList.imageSpacing) {
          ForEach(0..<uploadedImages.count, id: \.self) { index in
            uploadedImages[index]
              .resizable()
              .scaledToFill()
              .frame(width: imageSize, height: imageSize)
              .cornerRadius(4)
          }
          ImageUploadView(
            size: imageSize,
            photoItems: $photoItems,
            uploadedImages: $uploadedImages
          )
        }
      }
      .scrollIndicators(.hidden)
      .frame(minHeight: imageSize)
    }
  }

  static func calculateImageSize(from width: CGFloat) -> CGFloat {
    return (width - (3 * imageSpacing)) / 3.5
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
    Rectangle()
      .foregroundStyle(Color.TKFontGray)
      .frame(width: size, height: size)
      .cornerRadius(4)
      .overlay() {
        Image(systemName: "plus")
      }
      .onTapGesture {
        presentPhotoPicker = true
      }
      .photosPicker(isPresented: $presentPhotoPicker, selection: $photoItems)
      .onChange(of: photoItems) {
        Task {
          // NOTE(dvallar): If you care, optimize this.
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
