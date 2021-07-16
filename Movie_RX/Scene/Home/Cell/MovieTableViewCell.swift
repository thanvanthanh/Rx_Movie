//
//  MovieTableViewCell.swift
//  Movie_RX
//
//  Created by Thân Văn Thanh on 09/07/2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
