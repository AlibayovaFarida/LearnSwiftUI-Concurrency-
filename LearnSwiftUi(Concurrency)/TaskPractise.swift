//
//  TaskPractise.swift
//  LearnSwiftUi(Concurrency)
//
//  Created by Farida on 24.06.25.
//

import SwiftUI

@Observable class TaskPractiseViewModel {
    var image1: UIImage? = nil
    var image2: UIImage? = nil
    func fetchImage1() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else {return}
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image1 = UIImage(data: data)
                print("Successfully")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else {return}
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            self.image2 = UIImage(data: data)
        } catch {
            print(error.localizedDescription)
        }
    }
}
struct TaskPractiseHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("Click me 🥸") {
                    TaskPractise()
                }
            }
        }
    }
}
struct TaskPractise: View {
    @State var viewModel = TaskPractiseViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    var body: some View {
        VStack(spacing: 20) {
            if let image = viewModel.image1 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task{
//                await viewModel.fetchImage1()
//            }
//            Task{
//                await viewModel.fetchImage1()
//                await viewModel.fetchImage2()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage1()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
//            Task(priority: .high) {
////                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("high : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("medium : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print("low : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("utility : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .background) {
//                print("background : \(Thread.current) : \(Task.currentPriority)")
//            }
            
//            Task(priority: .low) {
//                print("Low: \(Thread.current) : TaskPriority(rawValue: \(Task.currentPriority.rawValue))")
//                
//                Task.detached {
//                    print("Low: \(Thread.current) : TaskPriority(rawValue: \(Task.currentPriority.rawValue)")
//                }
//            }
            
//        }
        .task {
            await viewModel.fetchImage1()
//            await viewModel.fetchImage2()
        }
    }
}

#Preview {
    TaskPractise()
}
