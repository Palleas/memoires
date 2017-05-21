import UIKit

protocol ItemType {
    var title: String { get }
    var icon: UIImage { get }
}

final class CommonListViewController: UITableViewController {
    
    static let Identifier = "CommonCell" // Generate this, maybe?
    
    var items = [ItemType]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonListViewController.Identifier, for: indexPath) as! CommonListCell
        cell.icon.image = items[indexPath.row].icon
        cell.title.text = items[indexPath.row].title
        
        return cell
    }
}
