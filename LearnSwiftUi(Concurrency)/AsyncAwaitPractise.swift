//
//  AsyncAwaitPractise.swift
//  LearnSwiftUi(Concurrency)
//
//  Created by Farida on 16.06.25.
//

import SwiftUI

class AsyncAwaitPractiseViewmodel: ObservableObject {
    @Published var dataArray: [String] = []
    
    func addTitle() {
        DispatchQueue.main.async {
            self.dataArray.append("Title1 : \(Thread.current)")
        }
    }
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title2 = "Title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title2)
                
                let title3 = "Title3 : \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor() async {
        
        let author1 = "Author1 : \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author2 : \(Thread.current)"
        // self.dataArray.append(author2)
        await MainActor.run {
            self.dataArray.append(author2)
            
            let author3 = "Author3 : \(Thread.current)"
            self.dataArray.append(author3)
        }
        
//        await addSomething()
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let something1 = "Something1 : \(Thread.current)"
        
        await MainActor.run {
            self.dataArray.append(something1)
            
            let something2 = "Something2 : \(Thread.current)"
            self.dataArray.append(something2)
        }
        
    }
}

struct AsyncAwaitPractise: View {
    @StateObject var viewModel: AsyncAwaitPractiseViewmodel = AsyncAwaitPractiseViewmodel()
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { title in
                Text(title)
            }
        }
        .onAppear {
            Task {
                await viewModel.addAuthor()
                await viewModel.addSomething()
                
                let finalText = "FINAL TEXT : \(Thread.current)"
                self.viewModel.dataArray.append(finalText)
            }
//            viewModel.addTitle()
//            viewModel.addTitle2()
        }
    }
}

#Preview {
    AsyncAwaitPractise()
}


