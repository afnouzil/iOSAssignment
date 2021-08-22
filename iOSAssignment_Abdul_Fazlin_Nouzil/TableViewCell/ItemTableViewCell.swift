//
//  ItemTableViewCell.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/18/21.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemDescription: UITextView!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var addToCartButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageLayerSetup()
        
        
    }
    
    func dataSourceSetup(item: Item, index: Int){
        
        self.itemDescription.text = item.description
        self.itemTitle.text = item.name
        self.itemPrice.text = " ₹ \(item.price)"
        let imageUrl = item.image.replacingOccurrences(of: "http", with: "https")
        self.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        self.addToCartButton.tag = index
        self.selectionStyle = .none
    }
    
    func imageLayerSetup(){
        let layer = itemImageView.layer
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
