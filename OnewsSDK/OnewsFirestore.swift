//
//  OnewsFirestore.swift
//  OnewsSDK
//
//  Created by Sizwe Khathi on 2024/04/13.
//

import Foundation
import FirebaseFirestore

class OnewsFirestore {
    
    func queryUserArticles(using query: Query, completion: @escaping ([Article]?, Error?) -> Void) {
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
    
    func deleteUserArticles(_ query: Query, completion: @escaping (Error?) -> Void) {
        
        query.getDocuments { [weak self] (querySnapshot, err) in
           
        guard let self else { return }
                
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
