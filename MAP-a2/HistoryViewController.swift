import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var purchaseRecords: [(quantity: Int, itemName: String, date: Date)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        print("purchaseRecords: \(purchaseRecords)")
    }
    
    func addPurchaseRecord(_ record: (quantity: Int, itemName: String, date: Date)) {
        purchaseRecords.append(record)
        print("Added purchase record: \(purchaseRecords)")
        tableView.reloadData() // 데이터가 추가될 때마다 테이블 뷰를 업데이트합니다.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let purchase = purchaseRecords[indexPath.row]
    
        cell.textLabel?.text = "\(purchase.quantity) X \(purchase.itemName)" // 수량과 상품명
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm a"
        let dateString = dateFormatter.string(from: purchase.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }

    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
