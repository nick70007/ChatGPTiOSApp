//
//  OpenAIService.swift
//  ChatGPT
//
//  Created by iMac on 31/01/23.
//

import Foundation
import Combine
import Alamofire

final class OpenAIService {
    
    func send(_ message: String) -> AnyPublisher<OpenAICompletionsResponse,Error> {
        let body = OpenAICompletionsBody(model: "text-davinci-003",
                                         prompt: message,
                                         temperature: 0.7,
                                         max_tokens: 256)
        
        let headers: HTTPHeaders = ["Authorization":"Bearer \(Constants.OPENAI_API_KEY)"]
        
        return Future { promise in
            AF.request(Constants.BASE_URL + "completions",
                       method: .post,
                       parameters: body,
                       encoder: .json,
                       headers: headers).responseDecodable(of: OpenAICompletionsResponse.self) { response in
                switch response.result {
                    case .success(let result): promise(.success(result))
                    case .failure(let error): promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
