import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    
//MARK: - Variables
    let locationButton = UIButton()
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
    }
    
//MARK: - ConfigureSearchBar
    func configureSearchBar() {
        view.addSubview(searchField)
        searchField.placeholder = "Type city"
        searchField.textColor = .white
        searchField.backgroundColor = .gray
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchField.widthAnchor.constraint(equalToConstant: 250),
            searchField.heightAnchor.constraint(equalToConstant: 50),
            searchField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300)
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
            print(error)
    }
}
