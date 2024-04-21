//
//  ArticleRequest.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/04/08.
//

import Foundation

open class ArticleRequest: OnewsArticleProtocol {
    
    public init() {}
    
    public typealias PerformNewsAPIRequestHandler = (_ result: Result<Data, Error>) -> Void
    public typealias FetchArticlesHandler = (_ result: NewsArticleResponse?, _ error: Error?) -> Void
    
    public func performNewsAPIRequest(with urlString: String,
                                   _ completion: @escaping PerformNewsAPIRequestHandler) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, _, error) in
                
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    } else if let safeData = data {
                        completion(.success(safeData))
                        return
                    }
                }
            }
            task.resume()
        }
    }
    
    public func handleGetArticlesRequest(_ url: String, completion: @escaping FetchArticlesHandler) {
        
        self.performNewsAPIRequest(with: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                completion(self.parseJSON(data), nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func parseJSON(_ newsData: Data) -> NewsArticleResponse? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(NewsArticleResponse.self, from: newsData)
            return decodedData.self
        } catch {
            return nil
        }
    }
}

public protocol OnewsArticleProtocol {
    func handleGetArticlesRequest(_ url: String, completion: @escaping (_ result: NewsArticleResponse?, _ error: Error?) -> Void)
}
