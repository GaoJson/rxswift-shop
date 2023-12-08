//
//  JSAddressCell.swift
//  shop
//
//  Created by zyjz on 2023/11/27.
//

import UIKit

class JSAddressCell: UITableViewCell {

    var callBack: ((_ index: Int) -> ())? = nil
    
    var index = 0
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var addressLb: UILabel!
    
    
    @IBOutlet weak var addressDetailLb: UILabel!
    
    @IBOutlet weak var userLb: UILabel!
    
    @IBAction func editAction(_ sender: UIButton) {
        
        self.callBack?(index)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editBtn.setTitle("", for: .normal)
        editBtn.setBackgroundImage(R.image.icon_edit(), for: .normal)
        editBtn.setBackgroundImage(R.image.icon_edit(), for: .selected)
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
