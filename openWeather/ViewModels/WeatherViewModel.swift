//
//  WeatherViewModel.swift
//  openWeather
//
//  Created by user on 2021/12/24.
//

import Foundation
import Combine
import UIKit

typealias WeatherSnapshot = NSDiffableDataSourceSnapshot<WeatherSection, WeatherRow>

protocol WeatherViewModelProtocol {
    var oneCallWeatherSnapshot: AnyPublisher<WeatherSnapshot, Never> { get }
}

class WeatherViewModel {
    private var cancellables = Set<AnyCancellable>()
    public var weatherOutput = PassthroughSubject<Void, Never>()
    public var iconImageOutput = PassthroughSubject<Data, Never>()
    public var errorOutput = PassthroughSubject<Error, Never>()
    @Published private(set) var weather : OneCall?
    private var snapshot = WeatherSnapshot()
    private let weatherSnapshotSubject: CurrentValueSubject<WeatherSnapshot, Never> = .init(.init())
    let defaults = UserDefaults.standard

    
    func getCurrentLocationWeather(lat: Float, lon: Float) {
        WeatherNetwork.shared.fetchData(url: Path.onecallWeather(lat: lat, lon: lon).url(), type: OneCall.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                    self.errorOutput.send(err)
                case .finished:
                    print("Finished")
                }
            }
            receiveValue: { [weak self] weatherData in
                guard let self = self else { return }
                self.weather = weatherData
                self.weatherOutput.send()
                self.prepareData()
            }
            .store(in: &cancellables)
    }

}
extension WeatherViewModel {
    var oneCallWeatherSnapshot: AnyPublisher<WeatherSnapshot, Never> {
        weatherSnapshotSubject.eraseToAnyPublisher()
    }
}

private extension WeatherViewModel {
    func prepareData() {
        snapshot = WeatherSnapshot()
        if let oneCallModel = weather  {
            let section = WeatherSection.today
            snapshot.appendSections([section])
            snapshot.appendItems([WeatherRow.todayCell(item: oneCallModel.current)], toSection: section)
            if let dailyModels = oneCallModel.daily, !dailyModels.isEmpty {
                let section = WeatherSection.daily
                snapshot.appendSections([section])
                snapshot.appendItems( dailyModels.map {
                    WeatherRow.dailyCell(item: $0)}, toSection: section)
            }
        }
        weatherSnapshotSubject.send(snapshot)
    }
}

enum WeatherSection: Hashable {
    case today
    case daily
}

enum WeatherRow: Hashable {
    case todayCell(item: Current?)
    case dailyCell(item: Daily?)
}
