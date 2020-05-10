//
//  Extension+UIImageView.swift
//  SimpleContactApp
//
//  Created by Aldo Leonardo on 09/05/20.
//  Copyright © 2020 Aldo Leonardo. All rights reserved.
//

import UIKit

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    func convertImageToBase64(_ image: UIImage) -> String? {
        return image.jpegData(compressionQuality: 0.5)?.base64EncodedString()
    }
}
