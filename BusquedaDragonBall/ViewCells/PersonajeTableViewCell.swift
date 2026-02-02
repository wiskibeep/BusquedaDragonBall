import UIKit

class PersonajeTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var PersonajeLabel: UILabel!
    @IBOutlet weak var FavoriteImage: UIImageView!
    
    var favoriteTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        FavoriteImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(favoriteTappedAction))
        FavoriteImage.addGestureRecognizer(tap)
    }

    @objc private func favoriteTappedAction() {
        favoriteTapped?()
    }

    func configure(with item: Personaje.Item) {
        PersonajeLabel.text = item.name

        if let urlString = item.image {
            ImageView.loadFrom(url: urlString)
        } else {
            ImageView.image = nil
        }
        
        let isFavorite = FavoritosManager.shared.esFavorito(id: item.id)
        FavoriteImage.image = isFavorite
            ? UIImage(systemName: "heart.fill")
            : UIImage(systemName: "heart")
        FavoriteImage.isHidden = false
    }
}
