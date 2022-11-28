//
//  TableViewDataProvider.swift
//  MyWeatherApp
//
//  Created by Андрей on 27.11.2022.
//

import UIKit

final class TableViewDataProvider: NSObject {
    private var viewModel: CollectionViewViewModel
    public var requestWeatherForLocation: ((String) -> Void)?
    
    init(with viewModel: CollectionViewViewModel) {
        self.viewModel = viewModel
    }
}

extension TableViewDataProvider: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let results = viewModel.locations
        return results.isEmpty ? 1 : results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        let results = viewModel.locations
        
        if results.isEmpty {
            content.text = "No Results"
            content.textProperties.alignment = .center
        } else {
            let location = results[indexPath.row]
            content.text = "\(location.name), \(location.country)"
        }
        
        cell.contentConfiguration = content
        return cell
    }
}

extension TableViewDataProvider: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let locations = viewModel.locations
        
        if !locations.isEmpty {
            let location = locations[indexPath.row]
            let locationName = StringConverter.createSafeQueryString(from: location.name)
            requestWeatherForLocation?(locationName)
        }
    }
}
