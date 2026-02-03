//
//  ViewController.swift
//  BusquedaDragonBall
//
//  Created by Tardes on 28/1/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!

    private var originalItems: [Personaje.Item] = []
    private var filteredItems: [Personaje.Item] = []
    private var isSearching: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        Task { [weak self] in
            guard let self else { return }
            if let pageResult = await PersonajeProvider.obtenerPersonajes(page: 1, limit: 1000) {
                self.originalItems = pageResult.items
                self.filteredItems = self.originalItems
                
                
                
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Personaje Cell", for: indexPath) as! PersonajeTableViewCell
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
