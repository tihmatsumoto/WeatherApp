//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Tiemi Matsumoto on 16/09/2024.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let locationTextField = WATextField()
    let alertMessage = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.33, green: 0.64, blue: 1.00, alpha: 1.00)
        
        configureLocationTextField()
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .actionSheet) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actionSheet.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func fetchWeather(location: String) {
        NetworkManager.shared.fetchWeather(location: location) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let currentWeather):
                showAlert(title: "Current weather for \(location)", message: currentWeather.location.name)
            case .failure(let error):
                showAlert(title: "Error", message: String(error.rawValue))
            }
        }
    }
    
    func pushFollowerListVC() {
        // implement error treatment
        //        guard isUsernameEntered else {
        //            presentGFAlert(title: "Empty Username", message: "Please enter a username to search. We need to know who to look for", buttonTitle: "Ok")
        //            return
        //        }
        
        locationTextField.resignFirstResponder()
        
        
        
        //        let followerListVC = FollowerListViewController(username: usernameTextField.text!)
        //        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    func configureLocationTextField() {
        view.addSubview(locationTextField)
        
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        
        locationTextField.delegate = self
        
        NSLayoutConstraint.activate([
            locationTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            locationTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchWeather(location: locationTextField.text!)
        return true
    }
}

