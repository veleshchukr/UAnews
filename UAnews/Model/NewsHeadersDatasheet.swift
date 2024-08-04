//
//  NewsHeadersDatasheet.swift
//  UAnews
//
//  Created by Ruslan Veleshchuk on 02.08.2024.
//

import Foundation


final class NewsHeadersDatasheet {
    
    var news = Response()
    var headers: Array<Header> = []
    let newsAPICaller = NewsAPICaller()
    let imageAPICaller = ImageAPICaller()
        
    func setDataToHeaders(completion: @escaping ([Header]) -> Void) {
        
        let publishedDateFormatter = DateFormatter()
        publishedDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        let hederDateFormatter = DateFormatter()
        hederDateFormatter.dateFormat = "HH:mm"
        
        newsAPICaller.loadData { [weak self] values in
            DispatchQueue.main.async {
                guard let self else { return }
                self.news = values

                for article in self.news.articles {
                    var header = Header()
                    
                    header.title = article.title
                    header.subTitle = article.source.name
                    if article.description != nil { header.description = article.description! }
                    if let date = publishedDateFormatter.date(from: article.publishedAt) {
                        header.time = hederDateFormatter.string(from: date)
                    }
                    if article.url != nil {
                        if let url = URL(string: article.url!) {
                            header.articleURL = url
                        } else { 
                            print("не вдалося пертворити article.url в URL")
                            continue }
                    } else { 
                        print("article.url is nil")
                        continue }
                    
                    if article.urlToImage != nil {
                        if let url = URL(string: article.urlToImage!) {
                            header.imageURL = url
                            header.hasImage = true
                        }
                    }
                    self.headers.append(header)
                }
                completion(self.headers)
            }
        }
    }
}
