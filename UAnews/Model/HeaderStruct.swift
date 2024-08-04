//
//  HeaderStruct.swift
//  UAnews
//
//  Created by Ruslan Veleshchuk on 03.08.2024.
//

import Foundation
import UIKit

struct Header {
    var title: String = ""
    var subTitle: String = ""
    var description: String = ""
    var time: String = ""
    var imageURL: URL?
    var articleURL: URL?
    var hasImage: Bool = false
}
