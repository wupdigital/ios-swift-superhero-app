//
//  CharactersDataSource.swift
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 11..
//  Copyright © 2018. W.UP. All rights reserved.
//

protocol CharactersDataSource {

    func loadCharacters(page: Page, onSuccess: @escaping ([Character]) -> Void, onError: @escaping () -> Void)

    func loadCharacter(characterId: Int, onSuccess: @escaping (Character?) -> Void, onError: @escaping () -> Void)

    func saveCharacters(characters: [Character], onSuccess: @escaping () -> Void, onError: @escaping () -> Void)
}
