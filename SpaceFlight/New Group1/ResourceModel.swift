//
//  ResourceModel.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/17/21.
//

import Foundation
import UIKit

struct Resource {
    let title : String
    let url   : String
    let image : String
    
    init(title: String, url: String, image: String) {
        self.title = title
        self.url   = url
        self.image = image
    }
}
