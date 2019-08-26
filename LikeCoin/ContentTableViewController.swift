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
    var refreshControl: UIRefreshControl!
    var emptyMessageLabel: UILabel!

    var contentAPI: URLRequestConvertible?
    var contentURLs: [URL] = []

    override func loadView() {
        super.loadView()

        tableView = UITableView(frame: .zero, style: .grouped)
        view = tableView

        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self

        let nib = UINib.init(nibName: "ContentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchContent), for: .valueChanged)
        tableView.addSubview(refreshControl)

        emptyMessageLabel = UILabel(frame: .zero)
        emptyMessageLabel.text = "There is no content\nPlease pull down to refresh";
        emptyMessageLabel.textColor = UIColor.lightGray
        emptyMessageLabel.numberOfLines = 0;
        emptyMessageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emptyMessageLabel.textAlignment = .center;
        emptyMessageLabel.sizeToFit()
        tableView.backgroundView = emptyMessageLabel;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContent()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showContent":
            let vc = segue.destination as! ContentViewController
            vc.content = sender as? Content
        default:
            break
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if contentURLs.count > 0 {
            tableView.separatorStyle = .singleLine;
            return 1
        }

        tableView.separatorStyle = .none
        emptyMessageLabel.isHidden = refreshControl.isRefreshing
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentURLs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContentTableViewCell
        let url = contentURLs[indexPath.row]
        if let content = ContentStore.shared.getContent(url: url) {
            cell.setContent(content)
        } else {
            // TODO: Show loading indication
            cell.empty()

            ContentStore.shared.getContentAsync(url: url) { (content, _) in
                if let content = content {
                    cell.setContent(content)
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = contentURLs[indexPath.row]
        if let content = ContentStore.shared.getContent(url: url) {
            performSegue(withIdentifier: "showContent", sender: content)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc func fetchContent() {
        guard let api = contentAPI else { return }
        refreshControl.beginRefreshing()
        emptyMessageLabel.isHidden = true
        Alamofire
            .request(api)
            .validate()
            .responseJSON { response in
                self.refreshControl.endRefreshing()

                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.contentURLs = []
                    for jsonObj in json["list"].arrayValue {
                        if let url = URL(string: jsonObj["referrer"].stringValue) {
                            self.contentURLs.append(url)
                        }
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
