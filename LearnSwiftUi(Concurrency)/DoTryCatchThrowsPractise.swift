//
//  DoTryCatchThrowsPractise.swift
//  LearnSwiftUi(Concurrency)
//
//  Created by Farida on 13.06.25.
//

import SwiftUI
enum NetworkError: String, CaseIterable, Error {
    case invalidData
    case invalidURL
    case unknownError
    
    var path: String {
        switch self {
        case .invalidData:
            return "Invalid data"
        case .invalidURL:
            return "Invalid url"
        case .unknownError:
            return "Something happen wrong..."
        }
    }
}
class DoTryCatchThrowsPractiseManager {
    private var isActive: Bool = false
    func getTitle() -> (title: String?, error: NetworkError?) {
        if isActive {
            return ("New title...", nil)
        } else {
            return (nil, .invalidData)
        }
    }
    
    func getTitle2() -> Result<String, NetworkError> {
        if isActive {
            return .success("New title...")
        } else {
            return .failure(.invalidURL)
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "New title..."
        } else {
            throw NetworkError.unknownError
        }
    }
}

class DoTryCatchThrowsPractiseViewModel: ObservableObject {
    private let manager = DoTryCatchThrowsPractiseManager()
    @Published var text: String = "Starting text..."
    
    func fetchTitle() {
//        let returnedValue = manager.getTitle()
//        if let newTitle = returnedValue.title {
//            text = newTitle
//        } else if let error = returnedValue.error {
//            text = error.path
//        }
        
//        let returnedValue2 = manager.getTitle2()
//        switch returnedValue2 {
//        case .success(let data):
//            text = data
//        case .failure(let error):
//            text = error.path
//        }
        
        do {
            let returnedValue3 = try manager.getTitle3()
            text = returnedValue3
        } catch let error {
            text = error.localizedDescription
        }
    }
}

struct DoTryCatchThrowsPractise: View {
    @StateObject var viewModel = DoTryCatchThrowsPractiseViewModel()
    var body: some View {
        Text(viewModel.text)
            .foregroundStyle(.white)
            .background(
                Rectangle()
                    .frame(width: 300, height: 300)
                    .foregroundStyle(.blue)
            ).onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoTryCatchThrowsPractise()
}
