//
//  APIService.swift
//  NewsIndo
//
//  Created by MACBOOK PRO on 23/04/24.
//

import Foundation
import Alamofire

class APIService{
    static let shared = APIService()
    
    private init(){}
    
    func fetchNews() async throws -> [NewsArticle]{
        guard let url = URL(string: Constant.newsUrl) 
        else {
            throw URLError(.badURL)
        }
        //set data, response data, handle error bawaan sistem
        let news = try await withCheckedThrowingContinuation { continuation in
            AF.request(url).responseDecodable(of: NewsModel.self) { response in
                switch response.result{
                case .success(let newsResponse):
                    continuation.resume(returning: newsResponse.data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        return news
    }
    
    func fetchNewsTribun() async throws -> [ArticleNewsTribun]{
        guard let url = URL(string: Constant.newsTribunURL)
        else{
            throw URLError(.badURL)
        }
        let newstribun = try await withCheckedThrowingContinuation{
            continuation in AF.request(url).responseDecodable(of: TribunNewsModel.self) {
                response in switch response.result{
                case .success(let newsResponse):
                    continuation.resume(returning: newsResponse.data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        return newstribun
    }
}
