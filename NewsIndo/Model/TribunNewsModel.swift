//
//  TribunNewsModel.swift
//  NewsIndo
//
//  Created by MACBOOK PRO on 23/04/24.
//

import Foundation
struct TribunNewsModel: Codable {
    let message: String
    let total: Int
    let data: [ArticleNewsTribun]
}

struct ArticleNewsTribun: Codable, Identifiable{
    var id : String {link}
    let title: String
    let link: String
    let contentSnippet, isoDate: String
    let image: String
}
