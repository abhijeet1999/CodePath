//
//  TaskTableViewCell.swift
//  PhotoScavengersApp
//
//  Created by Abhijeet Cherungottil on 8/30/25.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
