//
//  EartquakeViewModel.swift
//  TremorWatch
//
//  Created by EMTECH MAC on 12/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class EarthquakeViewModel {
    private let earthquakeService: EarthquakeService
    private let disposeBag = DisposeBag()

    // Outputs
    let earthquakes: BehaviorRelay<[Earthquake]> = BehaviorRelay(value: [])
    let errorMessage: PublishSubject<String> = PublishSubject()
   
    init(earthquakeService: EarthquakeService = EarthquakeService()) {
        self.earthquakeService = earthquakeService
        fetchEarthquakes()
    }
   
    private func fetchEarthquakes() {
        earthquakeService.fetchEarthquakes()
            .subscribe(
                onNext: { [weak self] earthquakes in
                    self?.earthquakes.accept(earthquakes)
                },
                onError: { [weak self] error in
                    self?.errorMessage.onNext(error.localizedDescription)
                }
            ).disposed(by: disposeBag)
    }
}

