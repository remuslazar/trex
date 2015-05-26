//
//  InfoAnnotationView.swift
//  Trex
//
//  Created by Remus Lazar on 25.05.15.
//  Copyright (c) 2015 Remus Lazar. All rights reserved.
//

import UIKit
import MapKit

class InfoAnnotationView: MKAnnotationView {
    
    private var infoLabel = UILabel()
    
    private struct Constants {
        static let MaxSize = CGSize(width: 80,height: 12)
    }
    
    var caption: String? {
        didSet {
            infoLabel.text = caption
            let size = infoLabel.sizeThatFits(Constants.MaxSize)
            bounds.size = CGSize(width: min(size.width, Constants.MaxSize.width),
                height: min(size.height, Constants.MaxSize.height))
            infoLabel.frame = bounds
            setNeedsDisplay()
        }
    }
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        bounds.size = Constants.MaxSize
        infoLabel.frame = bounds
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote).fontWithSize(Constants.MaxSize.height)
        infoLabel.minimumScaleFactor = 0.8
        infoLabel.textAlignment = NSTextAlignment.Center
        infoLabel.textColor = UIColor.blackColor()
        infoLabel.backgroundColor = UIColor.whiteColor()
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.alpha = 0.5
        self.addSubview(infoLabel)
        self.opaque = false
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
