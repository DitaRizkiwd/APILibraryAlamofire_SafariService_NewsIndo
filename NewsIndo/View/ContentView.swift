//
//  ContentView.swift
//  NewsIndo
//
//  Created by MACBOOK PRO on 23/04/24.
//

import SwiftUI
import SafariServices

struct ContentView: View {
    @StateObject private var newsViewModel = NewsViewModel()
    var body: some View {
        NavigationStack {
            List{
                ForEach(newsViewModel.articles){
                    article in
                    VStack(alignment:.leading, spacing: 16){
                        AsyncImage(url: URL(string: article.image.medium)) {
                            image in
                            image.resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        placeholder : {
                           waitingViewImage()
                        }
                        Text(article.title)
                            .font(.headline)
                        
                        Text(article.author)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        HStack{
                            Text(article.isoDate.relativeToCurrentDate())
                                .font(.subheadline)
                            Button{
                                let viewController = SFSafariViewController(url: URL(string: article.link)!)
                                UIApplication.shared.firstKeyWindow?.rootViewController?.present(viewController,animated: true)
                                
                            } label: {
                                Text("Selengkapnya")
                                    .font(.subheadline)
                                    .foregroundStyle(.cyan)
                            }
                            
                            
                        }
                    }
                    
                }
            }
            .listStyle(.plain)
            .navigationTitle(Constant.newsTitle)
            .task {
                await newsViewModel.fetchNews()
            }
            .overlay(newsViewModel.isLoading ? waitingView() : nil)
        }
        
    }
}

#Preview {
    ContentView()
}

@ViewBuilder
func waitingView() -> some View{
    VStack(spacing: 20){
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.cyan)

    }
}
@ViewBuilder
func waitingViewImage() -> some View{
    VStack(spacing: 20){
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.cyan)
        Text("Loading Image")
    }
}
extension UIApplication{
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes.compactMap{
            scene in scene as? UIWindowScene
        }
        .filter{
            filter in filter.activationState == .foregroundActive
        }
        .first?.keyWindow
    }
}
