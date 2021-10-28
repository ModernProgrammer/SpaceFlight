//
//  UIImageUrlLinkDownLoadProtocol.swift
//  SpaceFlight
//
//  Created by Diego Bustamante on 10/27/21.
//

import Foundation

protocol UIImageUrlLinkDownLoadProtocol {
    func downloadImage(from urlString: String, completion: ( (Result<Bool, ImageDownloadError>) -> Void)?)
}
