import UIKit

class PJAleatorioViewController: UIViewController {
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
        limpiarVista()
        Task { [weak self] in
            guard let self else { return }
            if let pageResult = await PersonajeProvider.obtenerPersonajes(page: 1, limit: 1000) {
                self.personajes = pageResult.items
            }
        }
        setFavoriteIcon()
    }
    
    func limpiarVista() {
        imagenPJ.image = nil
        descriptionPJ.text = ""
        poderPJ.text = ""
        MaxPoderPJ.text = ""
        RacePj.text = ""
        GenderPJ.text = ""
        NameLabel.text = ""
        setFavoriteIcon()
    }
    
    @IBAction func tryButtonTapped(_ sender: UIButton) {
        guard !personajes.isEmpty else { return }
        let randomPersonaje = personajes.randomElement()!
        personaje = randomPersonaje
        cargarDatos()
        setFavoriteIcon()
        showAlert(title:"Tu personaje aleatorio es:", message: personaje?.name ?? "no hay personajes")
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

    // MARK:  Aviso
    private func showAlert(title: String , message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    
    
    
    // MARK: - Favoritos

    /// Cambia el ícono del botón de favorito según si el personaje actual está en favoritos
    func setFavoriteIcon() {
        guard let personaje = personaje else {
            favoriteButtonItem.image = UIImage(systemName: "heart")
            return
        }
        let isFavorite = FavoritosManager.shared.esFavorito(id: personaje.id)
        favoriteButtonItem.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    
    
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        guard let personaje = personaje else { return }
        FavoritosManager.shared.alternarFavorito(id: personaje.id)
        setFavoriteIcon()
    }
}
