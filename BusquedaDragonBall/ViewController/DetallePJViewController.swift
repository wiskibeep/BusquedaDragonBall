import UIKit

class DetallePJViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var imagenPJ: UIImageView!
    @IBOutlet weak var descriptionPJ: UILabel!
   // @IBOutlet weak var nombrePJ: UILabel!

    @IBOutlet weak var TransformacionPJ: UICollectionView!

    
    
    @IBOutlet weak var poderPJ: UILabel!
    @IBOutlet weak var MaxPoderPJ: UILabel!
    @IBOutlet weak var RacePj: UILabel!
    @IBOutlet weak var GenderPJ: UILabel!
    
    
    var personaje: Personaje.Item!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = personaje.name
        TransformacionPJ.dataSource = self
        cargarDatos()
    }

    func cargarDatos() {
        //nombrePJ.text = personaje.name
        poderPJ.text = personaje.ki
        MaxPoderPJ.text = personaje.maxKi
        RacePj.text = personaje.race
        GenderPJ.text = personaje.gender
        descriptionPJ.text = personaje.description

        if let urlString = personaje.image {
            imagenPJ.loadFrom(url: urlString)
        } else {
            imagenPJ.image = nil
        }
        TransformacionPJ.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personaje.transformations?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformationCell", for: indexPath) as! TransformationCell
        if let transformation = personaje.transformations?[indexPath.row] {
            cell.configure(with: transformation)
        }
        return cell
    }
}
