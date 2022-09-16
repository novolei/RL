//
//  ImageUploader.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/15.
//

import UIKit

struct ImageUploader {
    
    static func uploadImage(image: UIImage?, completion: @escaping(String) -> Void) {
        guard let imageData = image!.jpegData(compressionQuality: 0.5) else { return }

        
    }
}
