import UIKit

class PJDayViewController: UIViewController {
    
    @IBOutlet weak var imagenPJ: UIImageView!
    @IBOutlet weak var descriptionPJ: UILabel!
    @IBOutlet weak var poderPJ: UILabel!
    @IBOutlet weak var MaxPoderPJ: UILabel!
    @IBOutlet weak var RacePj: UILabel!
    @IBOutlet weak var GenderPJ: UILabel!
    @IBOutlet weak var favoriteButtonItem: UIBarButtonItem!
    @IBOutlet weak var NameLabel: UILabel!
    
    
    
    
    
    var personajes: [Personaje.Item] = []
    var personaje: Personaje.Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { [weak self] in
            guard let self else { return }
            if let pageResult = await PersonajeProvider.obtenerPersonajes(page: 1, limit: 1000) {
                self.personajes = pageResult.items
            }
        }
        setFavoriteIcon()
    }
    
    // Acción del botón "Inténtalo"
    @IBAction func tryButtonTapped(_ sender: UIButton) {
        guard !personajes.isEmpty else { return }
        let randomPersonaje = personajes.randomElement()!
        personaje = randomPersonaje
        cargarDatos()
        setFavoriteIcon()
    }
    
    func cargarDatos() {
        guard let personaje = personaje else { return }
        poderPJ.text = personaje.ki
        MaxPoderPJ.text = personaje.maxKi
        RacePj.text = personaje.race
        GenderPJ.text = personaje.gender
        descriptionPJ.text = personaje.description
        NameLabel.text = personaje.name

        if let urlString = personaje.image {
            imagenPJ.loadFrom(url: urlString)
        } else {
            imagenPJ.image = nil
        }
        setFavoriteIcon()
    }
    
    // MARK: - Favoritos
    
    var isFavorite: Bool {
        guard let personaje = personaje else { return false }
        return FavoritosManager.shared.esFavorito(id: personaje.id)
    }
    
    @IBAction func SetFavorite(_ sender: Any) {
        guard let personaje = personaje else { return }
        FavoritosManager.shared.alternarFavorito(id: personaje.id)
        setFavoriteIcon()
    }
    
    func setFavoriteIcon() {
        if isFavorite {
            favoriteButtonItem.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteButtonItem.image = UIImage(systemName: "heart")
        }
    }
    
    // MARK: - Compartir
    
    var predicion: String? = ""
    
    @IBAction func share(_ sender: Any) {
        guard let personaje = personaje else { return }
        if let predicion = predicion {
            let text = "Mi personaje favorito es \(personaje.name): \(predicion)"
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}
