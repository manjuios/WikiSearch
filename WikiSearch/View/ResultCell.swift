//
//  ResultCell.swift
//  WikiSearch
//
//  Created by Manjunath Naragund on 23/06/18.
//  Copyright © 2018 Manjunath. All rights reserved.
//

import UIKit
import SDWebImage

class ResultCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var wikiDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var heightOfDesc: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellDesign()
    }
    
    override func prepareForReuse() {
        thumbnail.image = nil
        title.text = nil
        wikiDescription.text = nil
    }
    
   
    
    private func setupCellDesign() {
        
        let color = UIColor.gernerateRandomColor()
        
        wikiDescription.numberOfLines = 0
        containerView.layer.cornerRadius = 7
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 7).cgPath
        containerView.layer.shadowColor = color.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.masksToBounds = false
        
        
        thumbnail.layer.cornerRadius = thumbnail.bounds.size.width * 0.5
        thumbnail.clipsToBounds = true
        thumbnail.layer.borderWidth = 1.5
        thumbnail.layer.borderColor = color.cgColor
    }
    
    func configureCell(_ page: Pages) {
        title.text = "Title"
        if let text = page.title {
            title.text = text
        }
        
        if let imagePath = page.thumbnail {
            if let source = imagePath.source {
                if let url = URL(string: source) {
                    thumbnail.sd_setImage(with: url, placeholderImage: UIImage(named: "default-user"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
                } else {
                    thumbnail.image = UIImage(named: "default-user")
                }
            } else {
                thumbnail.image = UIImage(named: "default-user")
            }
        } else {
            thumbnail.image = UIImage(named: "default-user")
        }
        if let term = page.terms {
            if let desc = term.description {
                var message: String = "Description"
                var i = 0
                for des in desc {
                    if i == 0 {
                        message = des
                    } else {
                        message.append(" \(des)")
                    }
                    i += 1
                }
                wikiDescription.text = message.count == 0 ? "Description" : message
                let height = message.heightOfString(contentView.frame.size.width - 76)
                heightOfDesc.constant = height + 24
            }
        }
    }
}
