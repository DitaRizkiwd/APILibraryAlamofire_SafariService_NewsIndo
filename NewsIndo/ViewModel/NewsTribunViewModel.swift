//
//  NewsTribunViewModel.swift
//  NewsIndo
//
//  Created by MACBOOK PRO on 23/04/24.
//

import Foundation

@MainActor
class NewsTribunViewModel : ObservableObject {
    @Published var articles = [ArticleNewsTribun]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchNewsTribun() async{
        isLoading = true
        defer {isLoading = false}
        errorMessage = nil
        
        do{
            articles = try await APIService.shared.fetchNewsTribun()
//            isLoading = false
        }
        catch{
            errorMessage = " \(error.localizedDescription). Failed to fetch news from API"
            print(errorMessage ?? "N/A")
        }
    }
}
