//
//  DownloadImageWithAsyncAwaitAndEscapingAndCombine.swift
//  LearnSwiftUi(Concurrency)
//
//  Created by Farida on 13.06.25.
//

import SwiftUI
import Combine

class DownloadAsyncImageLoader {
    let url = URL(string: "https://picsum.photos/200")!
    func handleResponse(_ data: Data?, _ response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    func imageLoader(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        guard let url = URL(string: "https://picsum.photos/200") else {return}
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data, response)
            completionHandler(image, error)
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({$0})
            .eraseToAnyPublisher()
    }
    
    func downloadImageWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = handleResponse(data, response)
            return image
        } catch {
            throw error
        }
    }
}

class DownloadImageWithAsyncAwaitAndEscapingAndCombineViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadAsyncImageLoader()
    var cancellables = Set<AnyCancellable>()
    func fetchImage() async {
//        image = UIImage(systemName: "heart.fill")
//        loader.imageLoader { [weak self] image, error in
//            if let image = image {
//                self?.image = image
//            }
//        }
        
//        loader.downloadWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                
//            } receiveValue: { [weak self] image in
//                self?.image = image
//            }
//            .store(in: &cancellables)

        
        let image = try? await loader.downloadImageWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
}

struct DownloadImageWithAsyncAwaitAndEscapingAndCombine: View {
    @StateObject var viewModel = DownloadImageWithAsyncAwaitAndEscapingAndCombineViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }.onAppear {
            Task {
                await viewModel.fetchImage()
            }
        }
    }
}

#Preview {
    DownloadImageWithAsyncAwaitAndEscapingAndCombine()
}
