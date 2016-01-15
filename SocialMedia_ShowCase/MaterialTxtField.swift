//
//  MaterialTxtField.swift
//  SocialMedia_ShowCase
//
//  Created by Brad Gray on 1/5/16.
//  Copyright © 2016 Brad Gray. All rights reserved.
//

import UIKit

class MaterialTxtField: UITextField {
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        
        layer.borderWidth = 1.0
    }
    //For Placeholder
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 0, 10)
    }
    // For Editing Text
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 0, 10)
    }
  }
