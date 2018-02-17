//
//  CharactersRepository.swift
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 11..
//  Copyright © 2018. W.UP. All rights reserved.
//

class CharactersRepository: CharactersDataSource {

    private let localDataSource: CharactersDataSource
    private let remoteDataSource: CharactersDataSource

    init(localDataSource: CharactersDataSource, remoteDataSource: CharactersDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func loadCharacters(page: Page, onSuccess: @escaping ([Character]) -> Void, onError: @escaping () -> Void) {
        self.localDataSource.loadCharacters(page: page, onSuccess: { (characters: [Character]) in
            if characters.isEmpty {
                self.remoteDataSource.loadCharacters(page: page, onSuccess: { (characters) in
                    self.localDataSource.saveCharacters(characters: characters, onSuccess: {}, onError: {})
                    onSuccess(characters)
                }, onError: onError)
            } else {
                onSuccess(characters)
            }
        }, onError: {
            self.remoteDataSource.loadCharacters(page: page, onSuccess: { (characters) in
                self.localDataSource.saveCharacters(characters: characters, onSuccess: {}, onError: {})
                onSuccess(characters)
            }, onError: onError)
        })
    }

    func loadCharacter(characterId: Int, onSuccess: @escaping (Character?) -> Void, onError: @escaping () -> Void) {
        self.localDataSource.loadCharacter(characterId: characterId, onSuccess: { (character) in
            if let character = character {
                onSuccess(character)
            } else {
                self.remoteDataSource.loadCharacter(characterId: characterId, onSuccess: onSuccess, onError: onError)
            }
        }, onError: {
            self.remoteDataSource.loadCharacter(characterId: characterId, onSuccess: onSuccess, onError: onError)
        })
    }

    func saveCharacters(characters: [Character], onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        self.localDataSource.saveCharacters(characters: characters, onSuccess: {
            self.remoteDataSource.saveCharacters(characters: characters, onSuccess: {}, onError: {})
        }, onError: {
            self.remoteDataSource.saveCharacters(characters: characters, onSuccess: {}, onError: {})
        })
    }

}
