//
//  HeartTableViewCell.swift
//  BusquedaDragonBall
//
//  Created by Tardes on 3/2/26.
//

import UIKit

class HeartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var ImageCharater: UIImageView! // Si en el storyboard está así, déjalo igual
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Aquí sólo va la inicialización, NO declares configure aquí
    }
    
    func configure(with item: Personaje.Item) {
        lblNombre.text = item.name
        
        
        if let urlString = item.image {
            ImageCharater.loadFrom(url: urlString)
        } else {
            ImageCharater.image = nil
        }
    }
}
