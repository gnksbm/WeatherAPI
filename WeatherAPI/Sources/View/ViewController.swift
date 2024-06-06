//
//  ViewController.swift
//  WeatherAPI
//
//  Created by gnksbm on 6/5/24.
//

import UIKit

import Alamofire
import SnapKit

class ViewController: UIViewController {
    private let tempLabel = {
        let label = UILabel()
        return label
    }()
    
    private let humidityLabel = {
        let label = UILabel()
        return label
    }()
    
    private let windLabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchWeatherData()
    }
    
    private func fetchWeatherData() {
        if let url = API.weather.url {
            AF.request(url).responseDecodable(
                of: WeatherInfo.self
            ) { [weak self] response in
                guard let self else { return }
                switch response.result {
                case .success(let weatherInfo):
                    updateView(data: weatherInfo)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateView(data: WeatherInfo) {
        tempLabel.text = data.temperature
        humidityLabel.text = data.humidity
        windLabel.text = data.windSpeed
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        [tempLabel, humidityLabel, windLabel].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        tempLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(safeArea).offset(20)
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(20)
            make.leading.equalTo(tempLabel)
        }
        
        windLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(20)
            make.leading.equalTo(tempLabel)
        }
    }
}

