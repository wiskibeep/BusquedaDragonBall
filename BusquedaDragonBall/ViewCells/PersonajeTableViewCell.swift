//
//  PersonajeTableViewCell.swift
//  BusquedaDragonBall
//
//  Created by Tardes on 28/1/26.
//

import UIKit

class PersonajeTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var PersonajeLabel: UILabel!
    @IBOutlet weak var GenderView: UILabel!
    @IBOutlet weak var AffiationView: UILabel!
    @IBOutlet weak var KiLabel: UILabel!
    @IBOutlet weak var MaxLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with item: Personaje.Item) {
        PersonajeLabel.text = item.name

        if let urlString = item.image {
            ImageView.loadFrom(url: urlString)
        } else {
            ImageView.image = nil
        }

        GenderView.text = item.gender.isEmpty ? "N/A" : item.gender
        AffiationView.text = item.affiliation.isEmpty ? "N/A" : item.affiliation
        KiLabel.text = item.ki.isEmpty ? "N/A" : item.ki
        MaxLabel.text = item.maxKi.isEmpty ? "N/A" : item.maxKi
    }
}
