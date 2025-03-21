//
//  SongCell.swift
//  MusicPlayerApp
//
//  Created by Agil Febrianistian on 21/03/25.
//

import UIKit
import Lottie

class SongCell: UITableViewCell {
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var musicAnimation: LottieAnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        musicAnimation.loopMode = .loop
        musicAnimation.play()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
}
