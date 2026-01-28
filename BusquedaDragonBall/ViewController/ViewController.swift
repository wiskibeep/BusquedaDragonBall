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

    // Paginación
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private let pageSize: Int = 20
    private var isLoading: Bool = false
    private var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        // Cargar la primera página
        Task { [weak self] in
            await self?.loadPage(1, reset: true)
        }
    }

    // Cargar una página
    private func loadPage(_ page: Int, reset: Bool = false) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        if reset {
            currentPage = 1
            totalPages = 1
            originalItems.removeAll()
            filteredItems.removeAll()
            await MainActor.run { self.tableView.reloadData() }
        }

        guard let pageResult = await PersonajeProvider.obtenerPersonajes(page: page, limit: pageSize) else {
            return
        }

        currentPage = pageResult.meta.currentPage
        totalPages = pageResult.meta.totalPages

        let startIndex = originalItems.count
        originalItems.append(contentsOf: pageResult.items)

        // Si no hay búsqueda activa, el listado mostrado es el original
        if !isSearching {
            filteredItems = originalItems
            let endIndex = originalItems.count
            let newIndexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }

            await MainActor.run {
                if startIndex == 0 {
                    self.tableView.reloadData()
                } else {
                    self.tableView.insertRows(at: newIndexPaths, with: .automatic)
                }
            }
        } else {
            // Si hay búsqueda, volvemos a aplicar el filtro sobre originalItems
            await MainActor.run {
                self.applyCurrentSearch()
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

    // MARK: - UITableViewDelegate (infinite scroll)

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Si estamos mostrando los últimos 5 elementos y quedan páginas por cargar, pedimos la siguiente
        let threshold = 5
        let lastRowIndex = filteredItems.count - 1
        if indexPath.row >= lastRowIndex - threshold,
           !isLoading,
           !isSearching, // no cargamos más mientras se filtra, opcional
           currentPage < totalPages {
            Task { [weak self] in
                guard let self else { return }
                await self.loadPage(self.currentPage + 1)
            }
        }
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        applyCurrentSearch()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredItems = originalItems
        tableView.reloadData()
    }

    private func applyCurrentSearch() {
        if let query = navigationItem.searchController?.searchBar.text, !query.isEmpty {
            filteredItems = originalItems.filter { item in
                item.name.localizedCaseInsensitiveContains(query)
            }
        } else {
            filteredItems = originalItems
        }
        tableView.reloadData()
    }
}
