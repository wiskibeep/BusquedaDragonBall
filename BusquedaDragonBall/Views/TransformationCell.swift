import UIKit

class TransformationCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kiLabel: UILabel!

    func configure(with transformation: Personaje.Item.Transformation) {
       // nameLabel.text = transformation.name
        //kiLabel.text = transformation.ki
        if let urlString = transformation.image {
            imageView.loadFrom(url: urlString)
        } else {
            imageView.image = nil
        }
    }
}
