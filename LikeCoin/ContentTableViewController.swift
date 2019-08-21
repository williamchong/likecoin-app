//
//  ContentTableViewController.swift
//  LikeCoin
//
//  Created by David Ng on 21/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContentTableViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var contentList: [JSON] = []

    override func loadView() {
        super.loadView()

        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: "cell")
        view = tableView
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showContent":
            let vc = segue.destination as! ContentViewController
            vc.request = URLRequest(url: URL(string: sender as! String)!)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContentTableViewCell
        let url = contentList[indexPath.row]["referrer"].stringValue
        cell.fetchInfo(url: url)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = contentList[indexPath.row]["referrer"].stringValue
        performSegue(withIdentifier: "showContent", sender: urlString)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func fetchContent(api: URLRequestConvertible) {
        let hud = showLoadingHUD(text: "Fetching content")
        Alamofire
            .request(api)
            .validate()
            .responseJSON { response in
                hud.hide(animated: true)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.contentList = json["list"].arrayValue

                    if self.contentList.count == 0 {
                        self.alert(title: "Alert", message: "There is no content")
                    }
                    self.tableView.reloadData()

                case .failure(let error):
                    self.alert(
                        title: "Error on " + (response.response?.url!.absoluteString)!,
                        message: error.localizedDescription
                    )
                }
        }
    }
}
