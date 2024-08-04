//
//  ImageAPICaller.swift
//  UAnews
//
//  Created by Ruslan Veleshchuk on 03.08.2024.
//

import Foundation
import UIKit

final class ImageAPICaller {
    
    func loadImage(from urlAddress: URL, completion: @escaping (UIImage) -> Void)  {
        
        URLSession.shared.dataTask(with: urlAddress) { data, response, error in
                  if let error = error {
                      print(error)
                      return
                  }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            completion(image)
        }.resume()
    }
}
