//
//  NewsViewModel.swift
//  NewsIndo
//
//  Created by MACBOOK PRO on 23/04/24.
//

import Foundation

@MainActor
class NewsViewModel : ObservableObject{
    @Published var articles = [NewsArticle]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    func fetchNews() async{
        isLoading = true
        defer {isLoading = false}
        errorMessage = nil
        
        do{
            articles = try await APIService.shared.fetchNews()
//            isLoading = false
        }
        catch{
            errorMessage = " \(error.localizedDescription). Failed to fetch news from API"
            print(errorMessage ?? "N/A")
        }
    }
}
