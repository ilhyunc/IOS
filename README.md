# OrderTrack
OrderTrack is an iOS application designed to manage and track purchases, including functionalities to add, edit, and view purchase records.

## Features

- **Purchase Management**: Add, edit, and delete items from the inventory.
- **Purchase History**: View a detailed history of all purchase records.
- **Manager Access**: Secure manager code entry to access restricted functionalities.

## Video Demonstration


https://github.com/user-attachments/assets/6ad8c396-7ef5-4c8a-9ad0-569e5eb6d244


## Usage

### Main Features

1. **Purchase Management**:
   - Select an item and specify the quantity to buy.
   - Click the 'Buy' button to complete the purchase and record the transaction.

2. **Edit Inventory**:
   - Access the Edit screen via the manager button and entering the manager code.
   - Add new items or update existing ones, specifying the item name, price, and quantity.

3. **View Purchase History**:
   - Access the history screen to see all recorded purchases with details like item name, quantity, total price, and date.

### Code Structure

- **AppDelegate.swift**: Handles the application lifecycle.
- **SceneDelegate.swift**: Manages the window and scene lifecycle.
- **ViewController.swift**: Manages the main interface for purchasing items.
- **CustomTabBarController.swift**: Custom tab bar controller for navigating between screens.
- **EditViewController.swift**: Handles editing and updating the inventory items.
- **HistoryViewController.swift**: Displays the purchase history.
- **UpdateViewController.swift**: Manages the form for adding and updating items.

### UI Components

- **UIPickerView**: Displays the list of items available for purchase.
- **UILabel**: Shows the total value of the current selection.
- **UIButton**: 'Buy' button to confirm the purchase and manager button for accessing inventory management.
- **UITableView**: Displays the list of items in the inventory and the purchase history
