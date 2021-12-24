//
//  ViewController.swift
//  openWeather
//
//  Created by user on 2021/12/24.
//

import Combine
import CoreLocation
import SnapKit
import UIKit

class ViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.delegate = self
        tableView.register(TodayCell.self, forCellReuseIdentifier: TodayCell.id)
        tableView.register(DailyCell.self, forCellReuseIdentifier: DailyCell.id)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        if #available(iOS 15.0, *) {
            tableView.fillerRowHeight = 0
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<WeatherSection, WeatherRow>
    = .init(tableView: tableView) { [weak self] tableView, indexPath, item in
        guard let self = self else { return nil }
        switch item {
        case let .todayCell(item):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayCell.id, for: indexPath)
                    as? TodayCell else { return nil }
            cell.configure(with: item)
            return cell
        case let .dailyCell(item):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyCell.id, for: indexPath)
                    as? DailyCell else { return nil }
            cell.configure(with: item)
            return cell
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    let viewModel = WeatherViewModel()
    private var weatherAsText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        requestLocationIfNeeded()
        setupUIs()
        makeNavigationItem()
        makeConstaints()
        makeBindings()
    }
    
    @objc func requestLocationIfNeeded() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationRequest()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    requestLocationIfNeeded()
                }
            }
        default:
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func setupUIs() {
        extendedLayoutIncludesOpaqueBars = true
        view.addSubview(tableView)
    }
    
    private func makeConstaints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
    private func makeBindings() {
        viewModel.oneCallWeatherSnapshot.dropFirst()
            .sink { [weak self] snapshot in
                guard let self = self else { return }
                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
    }
}

extension ViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.getCurrentLocationWeather(lat: Float(currentLocation.latitude), lon: Float(currentLocation.longitude))
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Failed to find user's location.")
    }
    
    func locationRequest() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
}

extension ViewController {
    private func makeNavigationItem() {
        let rightItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(requestLocationIfNeeded))
        navigationItem.setRightBarButtonItems([rightItem], animated: false)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        switch model {
        case let .dailyCell(item):
            let detailVC = DetailViewController.init(model: item!)
            self.navigationController?.pushViewController(detailVC, animated: false)
        default:
            break
            
        }
    }
}
