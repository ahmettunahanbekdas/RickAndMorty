//
//  DetailsViewModel.swift
//  GenericNetworkLayer
//
//  Created by Ahmet Tunahan Bekdaş on 23.05.2024.
//

import Foundation
import SDWebImage

protocol DetailsViewModelDelegate {
    var view: DetailsViewDelegate? { get set }
    func viewDidLoad()
    func addFavorites()
}

class DetailsViewModel {
    weak var view: DetailsViewDelegate?
    private let character: CharacterDetailsModel
    
    init(character: CharacterDetailsModel) {
        self.character = character
    }
}

extension DetailsViewModel: DetailsViewModelDelegate {
    func viewDidLoad() {
        view?.configureImageView(with: character)
        view?.configureNameLabel()
        view?.configureSpeciesLabel()
        view?.configureStatusLabel()
        view?.configureGenderLabel()
        view?.configureFavoritesButton()
    }
    
    func addFavorites() {
        let selectedCharacter = CombinedCharacter(id: character.id, name: character.name, image: character.image)
        UserDefaultsService.updateFavorites(favorite: selectedCharacter, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                DispatchQueue.main.async {
                    self.view?.showAlert(title: "Succes!", message: "Character successfully added to favorites", action: "OK")
                }
                return
            }
            DispatchQueue.main.async {
                self.view?.showAlert(title: "Error!", message: error.rawValue, action: "OK")
            }
        }
    }
}
