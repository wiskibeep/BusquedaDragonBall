//
//  HeartViewController.swift
//  BusquedaDragonBall
//
//  Created by Tardes on 3/2/26.
//

import UIKit

class HeartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var originalItems: [Personaje.Item] = []
    private var filteredItems: [Personaje.Item] = []
    private var isSearching: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        Task { [weak self] in
            guard let self else { return }
            if let pageResult = await PersonajeProvider.obtenerPersonajes(page: 1, limit: 1000) {
                // Filtra solo los personajes que son favoritos
                let favoritos = pageResult.items.filter { FavoritosManager.shared.esFavorito(id: $0.id) }
                self.originalItems = favoritos
                self.filteredItems = favoritos
                await MainActor.run {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeartCell", for: indexPath) as! HeartTableViewCell
        let item = filteredItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }

    
    
    
    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        if isSearching {
            filteredItems = originalItems.filter { item in
                
                item.name.localizedCaseInsensitiveContains(searchText)
                
            }
        } else {
            filteredItems = originalItems
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredItems = originalItems
        tableView.reloadData()
    }

    // MARK: - Navegación a detalle

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetallePJViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let personaje = filteredItems[indexPath.row]
            detailViewController.personaje = personaje
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
