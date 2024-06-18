import UIKit

struct PurchaseRecord {
    let itemName: String
    let quantity: Int
    let totalPrice: Double
    let date: Date
}

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, EditViewControllerDelegate {
    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var displayList: UIPickerView!
    @IBOutlet weak var select: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var managerBtn: UIButton!
    
    var items = ["Computer", "Monitor"]
    var selectedNumber = ""
    var quantityArray = [4, 4]
    var priceArray = [400.99, 200.99]
    let managerCode = "1234"
    var total: Double = 0
    var purchaseRecords: [PurchaseRecord] = [] // PurchaseRecord의 배열로 변경
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.qty.layer.masksToBounds = true
        self.qty.layer.cornerRadius = 10
        self.displayList.dataSource = self
        self.displayList.delegate = self
        buyBtn.isEnabled = false
        qty.text = "0"
        updateTotalValue()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let itemName = items[row].padding(toLength: 20, withPad: " ", startingAt: 0)
        let itemQuantity = "\(quantityArray[row])".padding(toLength: 10, withPad: " ", startingAt: 0)
        let itemPrice = "\(priceArray[row])".padding(toLength: 10, withPad: " ", startingAt: 0)
        return "\(itemName)\(itemQuantity)$\(itemPrice)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = items[row]

        select.text = selectedItem
        updateTotalValue()
        updateBuyButtonState()
    }

    func updateTotalValue() {
        guard let enteredQuantity = Int(qty.text ?? "0"), let selectedRow = displayList?.selectedRow(inComponent: 0), selectedRow < priceArray.count else {
            totalValue.text = "$0.00"
            return
        }
        let selectedPrice = priceArray[selectedRow]
        total = Double(enteredQuantity) * selectedPrice
        totalValue.text = String(format: "$%.2f", total)
    }
    
    func updateBuyButtonState() {
        guard let enteredQuantity = Int(qty.text ?? "0"), enteredQuantity > 0 else {
            totalValue.textColor = .black
            buyBtn.isEnabled = false
            return
        }

        guard let selectedRow = displayList?.selectedRow(inComponent: 0), selectedRow < priceArray.count else {
            totalValue.textColor = .black
            buyBtn.isEnabled = false
            return
        }

        let selectedQuantity = quantityArray[selectedRow]
        if enteredQuantity > selectedQuantity {
            totalValue.textColor = .red
            buyBtn.isEnabled = false
        } else {
            totalValue.textColor = .black
            buyBtn.isEnabled = true
        }
    }
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        guard let selectedItem = select.text, let enteredQuantity = Int(qty.text ?? "0") else { return }
        
        let currentDate = Date() // 현재 시간을 가져옵니다.
        
        // totalPrice 계산
        guard let selectedRow = displayList?.selectedRow(inComponent: 0), selectedRow < priceArray.count else { return }
        let selectedPrice = priceArray[selectedRow]
        let totalPrice = Double(enteredQuantity) * selectedPrice
        
        let purchaseRecord = PurchaseRecord(itemName: selectedItem, quantity: enteredQuantity, totalPrice: totalPrice, date: currentDate)
        purchaseRecords.append(purchaseRecord)
        
        // 데이터 확인용 print문 추가
        print("Added purchase record: \(purchaseRecord)")
        
        let alert = UIAlertController(title: "Purchase Complete", message: "Your purchase has been recorded.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let historyVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController {
                // 이 부분에서 전달받은 데이터를 그대로 대입해줍니다.
                historyVC.purchaseRecords = self.purchaseRecords.map { record in
                    return (quantity: record.quantity, itemName: record.itemName, date: record.date)
                }
                self.navigationController?.pushViewController(historyVC, animated: true)
            }
        }))
        present(alert, animated: true, completion: nil)
        
        if let selectedRow = displayList?.selectedRow(inComponent: 0), selectedRow < quantityArray.count {
            quantityArray[selectedRow] -= enteredQuantity
        }
        
        qty.text = "0"
        selectedNumber = ""
        updateTotalValue()
        updateBuyButtonState()
        
        displayList.reloadAllComponents()
    }


    @IBAction func touchDigit(_ sender: UIButton) {
        guard let digitString = sender.titleLabel?.text else { return }
        
        if digitString == "🔙" {
            if !selectedNumber.isEmpty {
                selectedNumber.removeLast()
            }
        } else if digitString == "C" {
            selectedNumber = ""
            qty.text = "0"
        } else {
            selectedNumber += digitString
        }
        
        qty.text = selectedNumber
        updateTotalValue()
        updateBuyButtonState()
    }
    
    @IBAction func managerButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Manager Code", message: "Please enter the manager code:", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter code"
            textField.isSecureTextEntry = true
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] _ in
            guard let code = alertController?.textFields?.first?.text else { return }
            if code == self?.managerCode {
                // 현재 표시되어 있는 UIAlertController를 dismiss
                alertController?.dismiss(animated: true) {
                    // 다음 뷰 컨트롤러로 이동
                    self?.performSegue(withIdentifier: "NextViewSegue", sender: nil)
                }
            } else {
                // 매니저 코드가 올바르지 않으면 알림 표시
                let alert = UIAlertController(title: "Incorrect Code", message: "The entered code is incorrect. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tabBarVC = segue.destination as? UITabBarController {
            if let viewControllers = tabBarVC.viewControllers {
                for viewController in viewControllers {
                    if let editVC = viewController as? EditViewController {
                        // 에딧 뷰 컨트롤러로 데이터 전달
                        editVC.items = items
                        editVC.quantityArray = quantityArray
                        editVC.priceArray = priceArray
                        editVC.delegate = self // 델리게이트 설정
                    }
                    else if let historyVC = viewController as? HistoryViewController {
                        // 히스토리 뷰 컨트롤러로 데이터 전달
                        historyVC.purchaseRecords = purchaseRecords.map { record in
                            return (quantity: record.quantity, itemName: record.itemName, date: record.date)
                        }
                    }
                }
            }
        }
    }

    
    func didUpdateItems(items: [String], quantityArray: [Int], priceArray: [Double]) {
        // 데이터 업데이트 및 UI 갱신 로직 추가
        self.items = items
        self.quantityArray = quantityArray
        self.priceArray = priceArray
        displayList.reloadAllComponents()
    }
}
