//
//  TodayCell.swift
//  openWeather
//
//  Created by user on 2021/12/24.
//

import Foundation
import UIKit
import SnapKit

class DailyCell : UITableViewCell,RoyUIInterface {
    private lazy var weatherIcon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var tempLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.black
        return view
    }()
    
    private lazy var uviLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.black
        return view
    }()
    
    private lazy var pressureLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.black
        return view
    }()
    
    private lazy var windSpeedLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.black
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.blue
        return view
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIs()
        addCons()
    }
    
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setupUIs() {
        contentView.addSubview(weatherIcon)
        contentView.addSubview(tempLabel)
        contentView.addSubview(pressureLabel)
        contentView.addSubview(uviLabel)
        contentView.addSubview(windSpeedLabel)
        contentView.addSubview(timeLabel)

    }
    
    private func addCons() {
        weatherIcon.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(100)
        }
        tempLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(120)
            $0.top.equalToSuperview().offset(20)
        }
        
        pressureLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(120)
            $0.top.equalTo(tempLabel.snp.bottom)
        }
        uviLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(120)
            $0.top.equalTo(pressureLabel.snp.bottom)
        }
        windSpeedLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(120)
            $0.top.equalTo(uviLabel.snp.bottom)
            $0.bottom.equalToSuperview().offset(-20)
        }
        timeLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with model: Daily?) {
        guard let model = model else {
            return
        }
        tempLabel.text = String(format: "%.2f°C", (model.temp?.day ?? 0.0) - 273.15)
        pressureLabel.text = String(format: "%.2f", model.pressure ?? 0)
        uviLabel.text = String(format: "%.2f", model.uvi ?? 0)
        windSpeedLabel.text = String(format: "%.2f", model.wind_speed ?? 0)
        timeLabel.text = localString(from: model.dt ?? 0.0)
        if let firstIcon = model.weather?.first?.icon {
            setIconImage(name: firstIcon)
        }
        
    }
    
    private func setIconImage(name: String){
        guard let iconURL = Path.icon(name: name).url() else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: iconURL) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.weatherIcon.image = UIImage.init(data: data)
                }
            }
        }
    }

}
