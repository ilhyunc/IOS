import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 다른 버튼 추가
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        // 탭 바 설정
        tabBar.barTintColor = .white
        tabBar.tintColor = .blue
        
        // 뷰 컨트롤러 배열 초기화
        viewControllers = []
        
        // 새로운 뷰 컨트롤러 추가
        let storeItemListVC = StoreItemListViewController()
        storeItemListVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        let navigationController = UINavigationController(rootViewController: storeItemListVC)
        
        // Done으로 뒤로가기 버튼 타이틀 설정
        let backButton = UIBarButtonItem()
        backButton.title = "Done"
        navigationController.navigationBar.topItem?.backBarButtonItem = backButton
        
        viewControllers?.append(navigationController)
    }
    
    @objc func addButtonTapped() {
        // 다른 버튼 동작 구현
        print("Add button tapped")
    }
}
