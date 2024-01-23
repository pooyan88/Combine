//
//  APICaller.swift
//  Combine Training
//
//  Created by Pooyan J on 10/26/1402 AP.
//

import Foundation
import Combine

enum MyError: Error {
    case serverError, URLError
}

class APICaller {
    
    static let shared = APICaller()
    
    func fetchComponies()-> Future<[String], MyError> {
        return Future { promixe in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promixe(.success(["Apple", "Google", "Microsoft", "Facebook"]))
            }
        }
    }
}
