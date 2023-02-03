//
//  ChatGPTAPI.swift
//  ChatGPT
//
//  Created by iMac on 02/02/23.
//

import Foundation

class ChatGPTAPI {
    
    /// Properties
    private let apiKey: String
    private var historyList = [String]()
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    
    private var urlRequest: URLRequest {
        let url = URL(string: Constants.BASE_URL+"completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers.forEach{ request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
    
    private var headers: [String:String] {
        [
            "Content-Type":"application/json",
            "Authorization":"Bearer \(apiKey)"
        ]
    }
    
    private let basePrompt = "You are ChatGPT, a large language model trained by OpenAI. You answer as consisely as possible for each response (e.g. Don't be verbose). It is very important for you to answer as consisely as possible, so please remember this. If you are generating a list, do not have too many items.\n\n\n"
    
    private var historyListText: String {
        historyList.joined()
    }
    
    /// Init
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /// JSON Body
    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
        let body: [String:Any] = [
            "model": "text-chat-davinci-002-20221122",
            "temperature": 0.5,
            "max_tokens": 1024,
            "prompt": generateChatGPTPrompt(from: text),
            "stop": [
                "\n\n\n",
                "<|im_end|>"
            ],
            "stream": stream
        ]
        return try JSONSerialization.data(withJSONObject: body)
    }
    
    /// Generate ChatGPT prompt from the given text
    private func generateChatGPTPrompt(from text: String) -> String {
        var prompt = basePrompt + historyListText + "User: \(text)\n\n\nChatGPT:"
        if prompt.count > (4000 * 4) {
            _ = historyList.dropFirst()
            prompt = generateChatGPTPrompt(from: text)
        }
        return prompt
    }
    
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error> {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text)
        
        let (result, response) = try await urlSession.bytes(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw "Bad Response: \(httpResponse.statusCode)"
        }
        
        return AsyncThrowingStream<String, Error> { continuation in
            Task(priority: .userInitiated) {
                do {
                    var streamText = ""
                    for try await line in result.lines {
                        if line.hasPrefix("data: "),
                           let data = line.dropFirst(6).data(using: .utf8),
                           let response = try? self.jsonDecoder.decode(CompletionResponse.self, from: data),
                           let text = response.choices.first?.text {
                            streamText += text
                            continuation.yield(text)
                        }
                    }
                    self.historyList.append(streamText)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    func sendMessage(_ text: String) async throws -> String {
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text, stream: false)
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw "Bad Response: \(httpResponse.statusCode)"
        }
        
        do {
            let completionResponse = try self.jsonDecoder.decode(CompletionResponse.self, from: data)
            let responseText = completionResponse.choices.first?.text ?? ""
            self.historyList.append(responseText)
            return responseText
        } catch {
            throw error
        }
    }
}

extension String: Error {}

extension String: CustomNSError {
    
    public var errorUserInfo: [String : Any] {
        [
            NSLocalizedDescriptionKey: self
        ]
    }
}

struct CompletionResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let text: String
}
