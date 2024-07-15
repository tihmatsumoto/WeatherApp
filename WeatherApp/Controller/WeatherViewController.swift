import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    
//MARK: - Variables
    var locationButton = UIButton()
    let searchField = UISearchTextField()
    let actionSheet = UIAlertController()
    
    var weatherManager = WeatherManager()

//MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        searchField.delegate = self
        weatherManager.delegate = self
        
        configureUI()
    }

//MARK: - Configure UI
    
    func configureUI() {
        configureSearchBar()
        configureLocationButton()
    }
    
//MARK: - ConfigureSearchBar
    func configureSearchBar() {
        view.addSubview(searchField)
        searchField.placeholder = "Type city"
        searchField.textColor = .white
        searchField.backgroundColor = .gray
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchField.widthAnchor.constraint(equalToConstant: 280),
            searchField.heightAnchor.constraint(equalToConstant: 50),
            searchField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 30),
            searchField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -310)
        ])
    }
    
    func configureLocationButton() {
        view.addSubview(locationButton)
        let config = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        locationButton.setImage(UIImage(systemName: "location.circle.fill", withConfiguration: config), for: .normal)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationButton.leadingAnchor.constraint(equalTo: searchField.leadingAnchor, constant: -65),
            locationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -310)
        ])
    }

    
//MARK: - SearchField Delegate related methods
    func searchTyped(_sender: UITextField) {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != "" {
            return true
        } else {
            searchField.placeholder = "Search..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchField.text { //optional unwrap
            weatherManager.fetchWeather(cityName: city)
        }
        searchField.text = ""
    }

//MARK: - WeatherManagerDelegate
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        let description = "City/Country: \(weather.cityName), \(weather.countryName) \n Temperature: \(weather.temperature) \n Condition: \(weather.conditionDescription)"
        let alertController = UIAlertController(title: "Weather Conditions", message: "\(description)", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Return", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didFailWithError(error: any Error) {
//        let errorAlert = UIAlertController(title: "Error", message: "\(Error.self)", preferredStyle: .alert)
//        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        DispatchQueue.main.async {
//            self.present(errorAlert, animated: true, completion: nil)
//        }
    }
}
