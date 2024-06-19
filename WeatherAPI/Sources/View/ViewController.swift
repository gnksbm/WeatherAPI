//
//  ViewController.swift
//  WeatherAPI
//
//  Created by gnksbm on 6/5/24.
//

import UIKit
import CoreLocation

import Alamofire
import SnapKit
import Kingfisher

class ViewController: UIViewController {
    private lazy var locationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    } ()
    private let dateLabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.text = "날짜 정보 가져오는 중..."
        return label
    }()
    
    private let locationButton = {
        let button = UIButton(configuration: .plain())
        button.configuration?.preferredSymbolConfigurationForImage
        = UIImage.SymbolConfiguration(pointSize: 22)
        button.setImage(
            UIImage(systemName: "location.fill"),
            for: .normal
        )
        button.tintColor = .systemBackground
        return button
    }()
    
    private let locationLabel = {
        let label = UILabel()
        label.text = "위치 정보를 가져오는 중..."
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .left
        label.textColor = .systemBackground
        return label
    }()
    
    private let shareButton = {
        let button = UIButton(configuration: .plain())
        button.configuration?.preferredSymbolConfigurationForImage
        = UIImage.SymbolConfiguration(pointSize: 16)
        button.configuration?.titlePadding = 0
        button.setImage(
            UIImage(systemName: "square.and.arrow.up"),
            for: .normal
        )
        button.tintColor = .systemBackground
        return button
    }()
    
    private lazy var refreshButton = {
        let button = UIButton(configuration: .plain())
        button.configuration?.preferredSymbolConfigurationForImage
        = UIImage.SymbolConfiguration(pointSize: 16)
        button.setImage(
            UIImage(systemName: "arrow.clockwise"),
            for: .normal
        )
        button.tintColor = .systemBackground
        button.addTarget(
            self,
            action: #selector(refrechButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var headerStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                locationButton,
                locationLabel,
                shareButton,
                refreshButton
            ]
        )
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let tempLabel = WeatherInfoLabel(placeholder: "온도 정보 가져오는 중...")
    private let humidityLabel = WeatherInfoLabel(placeholder: "습도 정보 가져오는 중...")
    private let windLabel = WeatherInfoLabel(placeholder: "풍속 정보 가져오는 중...")
    
    private let weatherImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "arrow.down.circle.dotted")?
            .withConfiguration(
                UIImage.SymbolConfiguration(pointSize: 40)
            )
        imageView.tintColor = .secondaryLabel
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let greetingLabel = {
        let label = WeatherInfoLabel()
        label.text = "오늘도 행복한 하루 보내세요"
        return label
    }()
    
    private lazy var weatherStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                tempLabel,
                humidityLabel,
                windLabel,
                weatherImageView,
                greetingLabel
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        requestLocationAuthorization()
    }
    
    private func fetchLocationData(with location: CLLocation) {
        if let url = API.weather.makeLocationURL(with: location) {
            AF.request(url).responseDecodable(
                of: [WeatherLocation].self
            ) { [weak self] response in
                guard let self else { return }
                switch response.result {
                case .success(let weatherLocations):
                    if let weatherLocation = weatherLocations.first {
                        fetchWeatherData(with: weatherLocation.localNames.en)
                    }
                case .failure(let error):
                    dump(error)
                }
            }
        }
    }
    
    private func fetchWeatherData(with locationName: String) {
        if let url = API.weather.makeWeatherURL(with: locationName) {
            AF.request(url).responseDecodable(
                of: WeatherInfo.self
            ) { [weak self] response in
                guard let self else { return }
                switch response.result {
                case .success(let weatherInfo):
                    updateView(data: weatherInfo)
                case .failure(let error):
                    dump(error)
                }
            }
        }
    }
    
    private func updateView(data: WeatherInfo) {
        dateLabel.text = Date().formatted(dateFormat: .weatherHeader)
        Task {
            locationLabel.text = await data.coord.getLocationString()
        }
        weatherImageView.kf.setImage(with: data.weather.first?.imageURL)
        tempLabel.text = data.temperature
        humidityLabel.text = data.humidity
        windLabel.text = data.windSpeed
    }
    
    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.8869307041, green: 0.58258605, blue: 0.3910360932, alpha: 1)
        
        [dateLabel, headerStackView, weatherStackView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        dateLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(safeArea).offset(20)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.width.equalTo(safeArea).multipliedBy(0.5)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.equalTo(dateLabel)
            make.trailing.equalTo(safeArea).offset(-20)
        }
        
        weatherStackView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(20)
            make.leading.equalTo(dateLabel)
        }
    }
    
    private func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    @objc private func refrechButtonTapped() {
        locationManager.requestLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            fetchLocationData(with: location)
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        locationLabel.text = "위치 정보를 가져오는데 실패했습니다."
    }
}
