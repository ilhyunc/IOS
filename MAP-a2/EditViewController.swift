import UIKit

protocol EditViewControllerDelegate: AnyObject {
    func didUpdateItems(items: [String], quantityArray: [Int], priceArray: [Double])
}

class EditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    weak var delegate: EditViewControllerDelegate?

    var items: [String] = []
    var quantityArray: [Int] = []
    var priceArray: [Double] = []

    var pickerViewData: [String] {
        var data: [String] = []
        for (index, item) in items.enumerated() {
            let quantity = quantityArray[index]
            let price = priceArray[index]
            let firstLine = "\(item) (\(quantity))"
            let secondLine = "$ \(price)"
            data.append(firstLine + "\n" + secondLine)
        }
        return data
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EditCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditCell", for: indexPath)
        let item = items[indexPath.row]
        let quantity = quantityArray[indexPath.row]
        let price = priceArray[indexPath.row]
        let firstLine = "\(item) (\(quantity))"
        let secondLine = "$ \(price)"
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = firstLine + "\n" + secondLine
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        let selectedQuantity = quantityArray[indexPath.row]
        let selectedPrice = priceArray[indexPath.row]
        performSegue(withIdentifier: "EditSegue", sender: (selectedItem, selectedQuantity, selectedPrice))
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "EditSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditSegue" {
            if let updateVC = segue.destination as? UpdateViewController {
                updateVC.delegate = self
                if let data = sender as? (String, Int, Double) {
                    updateVC.selectedItem = data.0
                    updateVC.selectedQuantity = data.1
                    updateVC.selectedPrice = data.2
                }
            }
        }
    }
}

extension EditViewController: UpdateViewControllerDelegate {
    func didUpdateItem(item: String, price: Double, quantity: Int) {
        if let selectedIndex = tableView.indexPathForSelectedRow?.row {
            items[selectedIndex] = item
            priceArray[selectedIndex] = price
            quantityArray[selectedIndex] = quantity
            tableView.reloadRows(at: [IndexPath(row: selectedIndex, section: 0)], with: .automatic)

            delegate?.didUpdateItems(items: items, quantityArray: quantityArray, priceArray: priceArray)
        }
    }

    func didAddItem(item: String, price: Double, quantity: Int) {
        items.append(item)
        priceArray.append(price)
        quantityArray.append(quantity)
        tableView.reloadData()

        delegate?.didUpdateItems(items: items, quantityArray: quantityArray, priceArray: priceArray)
    }
}
