//
//  TribunNewsView.swift
//  NewsIndo
//
//  Created by MACBOOK PRO on 23/04/24.
//

import SwiftUI
import SafariServices

struct TribunNewsView: View {
    @StateObject private var newsTribunViewModel = NewsTribunViewModel()
    @State private var searchText : String = ""
    //@State private var isLoading = true
    
    var searchNewsResult : [ArticleNewsTribun] {
        //guard if yang dipakai hanya satu kondisi
        guard !searchText.isEmpty else{
            return newsTribunViewModel.articles
        }
        return newsTribunViewModel.articles.filter { article in
            article.title.lowercased()
                .contains(searchText.lowercased())
        }
    }
    var body: some View {
        NavigationStack {
            List{
                ForEach(searchNewsResult){
                    articletribun in
                    if newsTribunViewModel.isLoading{
                        HandleHStack(articletribun: articletribun)
                            .redacted(reason: .placeholder)
                    }
                    else{
                        HandleHStack(articletribun: articletribun)
                    }   
                }
            }
            .listStyle(.plain)
            .navigationTitle(Constant.newsTribunTitle)
            .task {
                newsTribunViewModel.isLoading = true
                await newsTribunViewModel.fetchNewsTribun()
                newsTribunViewModel.isLoading = false
            }
            .overlay{
                if searchNewsResult.isEmpty, newsTribunViewModel.isLoading {
                    waitingView()
                }
                if searchNewsResult.isEmpty, !newsTribunViewModel.isLoading{
                    ContentUnavailableView.search(text: searchText)
                }
            }
            .refreshable {
                newsTribunViewModel.isLoading = true
                await newsTribunViewModel.fetchNewsTribun()
                newsTribunViewModel.isLoading = false
            }
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search News")
        }
    }
}

#Preview {
    TribunNewsView()
}

struct HandleHStack: View {
    var articletribun : ArticleNewsTribun
    var body: some View {
        HStack(spacing : 16){
            AsyncImage(url: URL(string: articletribun.image)) {
                image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
            }
            placeholder : {
                waitingViewImage()
            }
            VStack (alignment: .leading, spacing: 8){
                Text(articletribun.title)
                    .font(.headline)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .lineLimit(2)
                
                
                HStack{
                    Text(articletribun.isoDate.relativeToCurrentDate())
                        .font(.subheadline)
                    Button{
                        let vc = SFSafariViewController(url: URL(string: articletribun.link)!)
                        UIApplication.shared.firstKeyWindow?.rootViewController?.present(vc,animated: true)
                        
                    } label: {
                        Text("| Selengkapnya")
                            .font(.subheadline)
                            .foregroundStyle(.cyan)
                    }
                    
                    
                }
                
            }
            
        }
    }
}
