//
//  ViewController.swift
//  searchBarTest
//
//  Created by Austin Lam on 9/29/20.
//

import UIKit

class ViewController: UIViewController {
    
    let fruitAry: [String] = ["Apples", "Apricots", "Avocados", "Bananas", "Boysenberries", "Blueberries", "Bing Cherry", "Cherries", "Cantaloupe", "Crab apples", "Clementine", "Cucumbers", "Damson plum", "Dinosaur Eggs", "Dates", "Dewberries", "Dragon Fruit", "Elderberry", "Eggfruit", "Evergreen Huckleberry", "Entawak", "Fig", "Farkleberry", "Finger Lime", "Grapefruit", "Grapes", "Gooseberries", "Guava", "Honeydew melon", "Hackberry", "Honeycrisp Apples", "Indian Prune", "Indonesian Lime", "Imbe", "Indian Fig", "Jackfruit", "Java Apple", "Jambolan", "Kiwi", "Kaffir Lime", "Kumquat", "Lime", "Longan", "Lychee", "Loquat", "Mango", "Mandarin Orange", "Mulberry", "Melon", "Nectarine", "Navel Orange", "Nashi Pear", "Olive", "Oranges", "Ogeechee Limes", "Oval Kumquat", "Papaya", "Persimmon", "Paw Paw", "Prickly Pear", "Peach", "Pomegranate", "Pineapple", "Quince", "Queen Anne Cherry", "Quararibea cordata", "Rambutan", "Raspberries", "Rose Hips", "Star Fruit", "Strawberries", "Sugar Baby Watermelon", "Tomato", "Tangerine", "Tamarind", "Tart Cherries", "Ugli Fruit", "Uniq Fruit", "Ugni", "Vanilla Bean", "Velvet Pink Banana", "Voavanga", "Watermelon", "Wolfberry", "White Mulberry", "Xigua", "Ximenia caffra fruit", "Xango Mangosteen Fruit Juice", "Yellow Passion Fruit", "Yunnan Hackberry", "Yangmei", "Zig Zag Vine fruit", "Zinfandel Grapes", "Zucchini"]
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    lazy var filtered: [String] = fruitAry
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // searchBar.searchTextField.clearButtonMode = .never
        searchBar.placeholder = "Search"
        tableView.dataSource = self
        searchBar.returnKeyType = UIReturnKeyType.default
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func updateFiltered(withString searchText: String) {
        filtered = fruitAry.filter({ (fruit) -> Bool in
            let temp: NSString = fruit as NSString
            let range = temp.range(of: searchText, options: .caseInsensitive)
            return searchText == "" ? true : range.location != NSNotFound
        })
        
        if filtered.count == 0 {
            filtered.append("No searches found")
        }
    }
    
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateFiltered(withString: searchText)
        
        searchBar.setShowsCancelButton(searchBar.text != "", animated: true)
        
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        updateFiltered(withString: searchBar.text!)
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = indexPath.row < filtered.count ? filtered[indexPath.row] : ""
        return cell
    }
    
}

//MARK: - Shrink and expand view for keyboard

extension ViewController {
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        self.bottomConstraint.constant = keyboardHeight - view.safeAreaInsets.bottom
        self.tableView.contentOffset.y += keyboardHeight - self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        self.bottomConstraint.constant = 0
        self.tableView.contentOffset.y -= keyboardHeight - self.view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}
