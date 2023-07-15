//
//  ViewController.swift
//

import UIKit

enum CharacterListState {
    case data
    case error
    case fatalError
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DetailViewControllerDelegate {
    func deleteCharacterData(with id: Int64) {
    }
    
    func updateCharacterData(_ character: Character) {
    }

    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    let errorView: ErrorView = {
        let view = ErrorView()
        view.isHidden = true
        return view
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private let manager = NetworkManager()
    private var characters: [CharacterResponseModel]? = []

    private func loadCharacters() {
        manager.fetchCharacters { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.characters = response.characters
                print("successful response getting")
                self.updateCharacterListState(.data)
                self.reloadData()
            case let .failure(error):
                print("Error loading characters:", error)
                self.updateCharacterListState(.error)
            }
        }
    }

    
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateCharacterListState(_ state: CharacterListState) {
        switch state {
        case .data:
            tableView.isHidden = false
            errorView.isHidden = true
        case .error:
            tableView.isHidden = false
            errorView.isHidden = true
        case .fatalError:
            tableView.isHidden = true
            errorView.isHidden = false
        }
    }
    
    private func tableViewSetup() {
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterTableViewCell")
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor.clear
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        errorView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControl
        errorView.delegate = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "characterCell")
        view.addSubview(tableView)
        
        loadCharacters()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewController = DetailViewController()
        
        detailViewController.delegate = self
        
        present(detailViewController, animated: true)

        if let character = characters?[indexPath.row] {
            let obtainedCharacter = Character(dataID: Int64(character.id), id: character.id, name: character.name, image: character.image, species: character.species, status: character.status, gender: character.gender, location: character.location.location)
            detailViewController.data = obtainedCharacter
        }
    }

    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterTableViewCell")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell", for: indexPath) as? CharacterTableViewCell else {
            fatalError("Couldn't dequeue cell with identifier: CharacterTableViewCell")
        }
        if let character = characters?[indexPath.row] {
            let obtainedCharacter = Character(dataID: Int64(character.id), id: character.id, name: character.name, image: character.image, species: character.species, status: character.status, gender: character.gender, location: character.location.location)
            cell.setUpData(obtainedCharacter)
            cell.setUpViews()
        }
        cell.backgroundColor = .systemBackground
        return cell
    }

    @objc func refresh(_ sender: AnyObject) {
        loadCharacters()
        sender.endRefreshing()
    }
}

extension ViewController: RefreshDelegate {
    func refreshPage() {
        loadCharacters()
    }
}
