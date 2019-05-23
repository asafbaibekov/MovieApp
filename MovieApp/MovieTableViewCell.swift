//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Asaf Baibekov on 07/04/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

	var imageURL: URL!

	@IBOutlet weak var movieImageView: UIImageView!
	
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBOutlet weak var releaseYearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
