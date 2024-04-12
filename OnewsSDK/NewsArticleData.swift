//
//  NewsArticleData.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/24.
//

import Foundation

// MARK: - NewsArticle
public struct NewsArticle: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

// MARK: - Article
public struct Article: Codable {
    public var source: Source
    public var author: String?
    public var title: String
    public var description: String?
    public var url: String
    public var urlToImage: String?
    public var publishedAt: String
    public var content: String?
    public var uuid: String?
    
    public enum ArticleCodingKeys: CodingKey {
            case source
            case author
            case title
            case description
            case url
            case urlToImage
            case publishedAt
            case content
            case uuid
        }

        public init(from decoder: Decoder, uuid: String?) throws {
            let container = try decoder.container(keyedBy: ArticleCodingKeys.self)
            self.source = try container.decode(Source.self, forKey: .source)
            self.author = try? container.decode(String.self, forKey: .author)
            self.title = try container.decode(String.self, forKey: .title)
            self.description = try container.decode(String.self, forKey: .description)
            self.url = try container.decode(String.self, forKey: .url)
            self.urlToImage = try? container.decode(String.self, forKey: .urlToImage)
            self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
            self.content = try? container.decode(String.self, forKey: .publishedAt)
            self.uuid = uuid
        }
}

// MARK: - Source
public struct Source: Codable {
    public var id: String?
    public var name: String?
}
