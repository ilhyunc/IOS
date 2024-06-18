import UIKit

protocol UpdateViewControllerDelegate: AnyObject {
    func didAddItem(item: String, price: Double, quantity: Int)
    func didUpdateItem(item: String, price: Double, quantity: Int)
}

class UpdateViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemsTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: UpdateViewControllerDelegate?

    var selectedItem: String?
    var selectedPrice: Double?
    var selectedQuantity: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = selectedItem, let price = selectedPrice, let quantity = selectedQuantity {
            itemsTextField.text = item
            priceTextField.text = "\(price)"
            quantityTextField.text = "\(quantity)"
        }
        configureUI()
    }

    private func configureUI() {
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let newItem = itemsTextField.text,
              let newPriceString = priceTextField.text,
              let newQuantityString = quantityTextField.text,
              let newPrice = Double(newPriceString),
              let newQuantity = Int(newQuantityString) else {
            return
        }

        if let _ = selectedItem, let _ = selectedPrice, let _ = selectedQuantity {
            delegate?.didUpdateItem(item: newItem, price: newPrice, quantity: newQuantity)
        } else {
            delegate?.didAddItem(item: newItem, price: newPrice, quantity: newQuantity)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
