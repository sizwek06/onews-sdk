//
//  OnewsFirestore.swift
//  OnewsSDK
//
//  Created by Sizwe Khathi on 2024/04/13.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestoreInternal

open class OnewsFirestore {
    
    public init() {}
    
    public func saveNewsArticle(using newsArticle: Article, userUID: String, completion: @escaping (Error?) -> Void) {
        do {
            var dbArticle = newsArticle
            dbArticle.uuid = userUID
            
            try Firestore.firestore().collection("newsArticles")
                .document()
                .setData(from: dbArticle)
            completion(nil)
            } catch {
                completion(error)
        }
    }
    
    public func queryUserArticles(using query: Query, completion: @escaping ([Article]?, Error?) -> Void) {
        var articlesArray = [Article]()
        
        query.getDocuments { (snapshot, error) in
            
            guard let querySnapshot = snapshot else {
                if let error = error {
                    completion(nil, error)
                }
                return
            }
            
            for document in querySnapshot.documents {
                
                articlesArray.append(try! document.data(as: Article.self))
            }
            completion(articlesArray, nil)
        }
    }
    
    public func deleteUserArticles(_ query: Query, completion: @escaping (Error?) -> Void) {
        
        query.getDocuments { (querySnapshot, err) in
                
          if let err = err {
              completion(err)
          } else {
            for document in querySnapshot!.documents {
              document.reference.delete()
            }
              completion(nil)
          }
        }
    }
}
