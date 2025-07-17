//
//  AsyncLetPractise.swift
//  LearnSwiftUi(Concurrency)
//
//  Created by Farida on 26.06.25.
//

import SwiftUI

struct AsyncLetPractise: View {
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    let url = URL(string: "https://picsum.photos/200")!
    @State var images: [UIImage] = []
    @State var mainTitle: String = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle(mainTitle)
            .onAppear {
                Task {
                    do {
                        async let fetchTitle = fetchTitle()
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        
                        let (title, image1, image2, image3, image4) = await (fetchTitle, try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
                        mainTitle = title
                        images.append(contentsOf: [image1, image2, image3, image4])
                        
    //                    let image1 = try await fetchImage()
    //                    images.append(image1)
    //                    let image2 = try await fetchImage()
    //                    images.append(image2)
    //                    let image3 = try await fetchImage()
    //                    images.append(image3)
    //                    let image4 = try await fetchImage()
    //                    images.append(image4)

                    } catch {
                        throw error
                    }
                }
            }
        }
    }
    func fetchTitle() async -> String {
        return "Helloooooo"
    }
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _ ) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

#Preview {
    AsyncLetPractise()
}
