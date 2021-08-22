//
//  HTTPUtility.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/19/21.
//

import Foundation


// MARK: - GET Api

class HTTPUtility {
    
    
    static let shared = HTTPUtility()
    private init(){}

    
    func getData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, Error>)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: requestUrl) { (data, httpUrlResponse, error) in

            if let statusCode = (httpUrlResponse as? HTTPURLResponse)?.statusCode{
                print(statusCode)
                
                do{
                    let response =  try JSONDecoder().decode(T.self, from: data!)
                    completionHandler(.success(response))

                }
                catch let error {
                    completionHandler(.failure(error))

                }

            }

        }.resume()
    }
    

}

