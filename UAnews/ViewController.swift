//
//  ViewController.swift
//  UAnews
//
//  Created by Ruslan Veleshchuk on 01.08.2024.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    
    var headers: Array<Header> = []
    var backUpHeaders: Array<Header> = []
    let newsHeadersDatasheet = NewsHeadersDatasheet()
    let imageAPICaller = ImageAPICaller()

    func setDataToTable() {
        newsHeadersDatasheet.setDataToHeaders() { [weak self] values in
            DispatchQueue.main.async {
                guard let self else { return }
                self.headers = values
                self.backUpHeaders = self.headers
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDataToTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.searchBar.delegate = self
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fullNews = SFSafariViewController(url: headers[indexPath.row].articleURL!)
        present(fullNews, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if headers[indexPath.row].hasImage {
            return 200
        } else {
            return 100
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        if headers[indexPath.row].hasImage {
            cell = tableView.dequeueReusableCell(withIdentifier: "isImageCell", for: indexPath)

            imageAPICaller.loadImage(from: headers[indexPath.row].imageURL!) { [weak self] values in
                                DispatchQueue.main.async {
                                    guard self != nil else { return }
                                    (cell.viewWithTag(5) as? UIImageView)?.image = values
                                }
                            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "noImageCell", for: indexPath)
        }
        
        (cell.viewWithTag(1) as? UILabel)?.text = "🔴 \(headers[indexPath.row].title)"
        (cell.viewWithTag(2) as? UILabel)?.text = headers[indexPath.row].subTitle
        (cell.viewWithTag(3) as? UILabel)?.text = headers[indexPath.row].description
        (cell.viewWithTag(4) as? UILabel)?.text = headers[indexPath.row].time
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredHeaders: Array<Header> = []
        
        self.headers = self.backUpHeaders
        self.tableView.reloadData()
        
        let filter = searchText.lowercased()
        if filter == "" { return }
        
        for index in self.headers.indices {
            if headers[index].title.lowercased().contains(filter) || headers[index].subTitle.lowercased().contains(filter) || headers[index].description.lowercased().contains(filter) {
                filteredHeaders.append(headers[index])
            }
        }
        self.headers = filteredHeaders
        self.tableView.reloadData()
    }
}
