//
//  GetCharacterUseCase.swift
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 12..
//  Copyright © 2018. W.UP. All rights reserved.
//

struct GetCharacterRequest: UseCaseRequest {
    let characterId: Int

    init(characterId: Int) {
        self.characterId = characterId
    }
}

struct GetCharacterResponse: UseCaseResponse {
    let character: Character?

    init(character: Character?) {
        self.character = character
    }
}

class GetCharacterUseCase: UseCase<GetCharacterRequest, GetCharacterResponse> {

    private var charactersDataSource: CharactersDataSource

    init(charactersDataSource: CharactersDataSource) {
        self.charactersDataSource = charactersDataSource
    }

    override func executeUseCase(request: GetCharacterRequest) throws {
        self.charactersDataSource.loadCharacter(characterId: request.characterId, onSuccess: { (character) in
            
            if let onSuccess = self.onSuccess {
                let response = GetCharacterResponse(character: character)
                onSuccess(response)
            }
        }, onError: {
            if let onError = self.onError {
                onError()
            }
        })
    }
}
