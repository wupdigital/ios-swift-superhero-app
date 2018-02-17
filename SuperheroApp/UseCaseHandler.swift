//
//  UseCaseHandler.swift
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 12..
//  Copyright © 2018. W.UP. All rights reserved.
//

class UseCaseHandler {

    private let useCaseScheduler: UseCaseScheduler

    init(useCaseScheduler: UseCaseScheduler) {
        self.useCaseScheduler = useCaseScheduler
    }

    func executeUseCase<Rq, Rs>(useCase: UseCase<Rq, Rs>,
                                request: Rq,
                                onSuccess: @escaping (Rs) -> Void,
                                onError: @escaping () -> Void) {
        useCase.request = request
        useCase.onSuccess = { (response: Rs) in
            self.notifyResponse(onSuccess: onSuccess, response: response)
        }
        useCase.onError = {
            self.notifyError(onError: onError)
        }

        self.useCaseScheduler.execute {
            do {
                try useCase.run()
            } catch {
                print("UseCase execution failed: \(error)")
            }
        }
    }

    private func notifyResponse<Rs: UseCaseResponse>(onSuccess: @escaping (Rs) -> Void, response: Rs) {
        self.useCaseScheduler.notifyResponse(callback: onSuccess, response: response)
    }

    private func notifyError(onError: @escaping () -> Void) {
        self.useCaseScheduler.notifyError {
            onError()
        }
    }

}
