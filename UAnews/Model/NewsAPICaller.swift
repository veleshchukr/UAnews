//
//  NewsAPICaller.swift
//  UAnews
//
//  Created by Ruslan Veleshchuk on 01.08.2024.
//

import Foundation

final class NewsAPICaller {
    private let endPoint = "https://newsapi.org/v2/top-headlines?"
    private let params = "country=ua&apiKey="
    private let apiKey = "dd040bec097c46d58ea5d5748510c267"
    private var urlString: String = ""
    
    func loadData(completion: @escaping (Response) -> Void)  {
        var news = Response()
        urlString = endPoint + params + apiKey
        
        guard
            let urlAddress = URL(string: urlString)
        else {
            print ("не вдалося перетворити urlString в urlAddress")
            return
        }
        
        URLSession.shared.dataTask(with: urlAddress) { data, response, error in
                  if let error = error {
                      print(error)
                      return
                  }
                  guard let data = data else { return }

                  do {
                      let decoder = JSONDecoder()
                      news = try decoder.decode(Response.self, from: data)
                      completion(news)
                  } catch {
                      print(error)
                  }
        }.resume()
    }
}
