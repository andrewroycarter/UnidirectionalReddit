//
//  ViewController.swift
//  UnidirectionalReddit
//
//  Created by Demo on 2/17/17.
//  Copyright © 2017 WillowTree. All rights reserved.
//

import UIKit
import SafariServices
import ReSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, StoreSubscriber {
    
    // MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var statusView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    let api = RedditAPI()
    var posts: [Post] = []
    let store = Store<AppState>(reducer: AppReducer(), state: nil)
    lazy var loadPostsActionCreator: (String) -> Store<AppState>.ActionCreator = {
        getPosts(with: self.api)
    }()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableViewDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self, selector: ViewModel.init)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        store.unsubscribe(self)
    }
    
    // MARK: - Instance Methods
    
    func tableViewDidAppear() {
        tableView.flashScrollIndicators()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        if let url = post.permalinkURL {
            let controller = SFSafariViewController(url: url)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        store.dispatch(AppAction.updateSubreddit(searchText))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        store.dispatch(loadPostsActionCreator(text))
        searchBar.resignFirstResponder()
    }
    
    // MARK: - StoreSubscriber Methods
    
    func newState(state: ViewModel) {
        searchBar.text = state.searchBarText
        statusView.isHidden = state.statusViewHidden
        activityIndicatorView.isHidden = state.activityIndicatorHidden
        statusLabel.isHidden = state.statusLabelHidden
        statusLabel.text = state.statusMessage
        
        if posts.count != state.posts.count {
            posts = state.posts
            tableView.reloadData()
        }
    }
    
}

