//
//  FeedsTableViewCell.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var imgViewPic: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
