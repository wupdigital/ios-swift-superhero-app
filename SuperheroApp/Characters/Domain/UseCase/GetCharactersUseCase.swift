//
//  CharactersUseCase.swift
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 12..
//  Copyright © 2018. W.UP. All rights reserved.
//

struct GetCharactersRequest: UseCaseRequest {
    var page: Page
}

struct GetCharactersResponse: UseCaseResponse {
    var characters: [Character]
}

class GetCharactersUseCase: UseCase<GetCharactersRequest, GetCharactersResponse> {
    
    private let charactersDataSource: CharactersDataSource
    
    init(charactersDataSource: CharactersDataSource) {
        self.charactersDataSource = charactersDataSource
    }
    
    override func executeUseCase(request: GetCharactersRequest) throws {
        self.charactersDataSource.loadCharacters(page: request.page, complete: { (characters) in
            let response = GetCharactersResponse()
            response.characters = characters
            self.success(response)
        }, fail: {
            self.error()
        })
    }
}
