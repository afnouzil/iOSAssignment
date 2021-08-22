//
//  ViewController.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/18/21.
//

import UIKit
import SDWebImage

class ItemListViewController: UIViewController {
    
    @IBOutlet var itemListTableView: UITableView!
    
    private var items = [Item]()
    private var fetchOffSet = 0
    var itemPresenter: ItemViewPresentation?
    var cartPresenter: CartViewPresentation?
    let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        displayData()
        pullToRefreshSetup()
    }
    
    func initialSetup(){
        
        self.title = Constants.itemTitle
        itemListTableView.register(UINib(nibName: Identifier.ItemTableViewCell, bundle: nil), forCellReuseIdentifier: Identifier.itemCellIdentifier)

        SDImageCache.shared.config.maxDiskSize = 1_000 * 10
    }
    
    func displayData(){
        items.removeAll()
        guard let presenter = itemPresenter else {
            return
        }
        if presenter.isItemDBEmpty() {
            presenter.getItemsAndSaveToDB()
        }else{
            presenter.getItemsBy(fetchOffSet)
        }
    }
    
    func pullToRefreshSetup()  {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        itemListTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        displayData()
        refreshControl.endRefreshing()
    }

    
    @IBAction func cartButtonPressed(_ sender: UIBarButtonItem) {
        self.itemPresenter?.gotoCartListViewController(viewController: self)
    }
    
}
extension ItemListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.itemCellIdentifier) as? ItemTableViewCell else{ return UITableViewCell() }
        cell.dataSourceSetup(item: items[indexPath.row], index: indexPath.row)
        cell.addToCartButton.addTarget(self, action: #selector(addToCartButtonPressed(button:)), for: .touchUpInside)

        return cell
    }
    @objc func addToCartButtonPressed(button:UIButton){
        let pressedIndex = button.tag
        let item = items[pressedIndex]
        cartPresenter?.addItemToCart(item, viewController: self)
    }

    
}
extension ItemListViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset: CGFloat = scrollView.contentOffset.y
        let scrollViewHeight: CGFloat = scrollView.frame.size.height
        let scrollViewContentSizeHeight: CGFloat = scrollView.contentSize.height
        
        print(currentOffset)
        print(scrollViewHeight)
        print(scrollViewContentSizeHeight)
        
        if ((currentOffset + scrollViewHeight) > scrollViewContentSizeHeight ) {
            setupPagination()
        }
    }
    
    func setupPagination(){
        if self.items.count >= 10 {
            fetchOffSet = fetchOffSet + 10
            self.itemPresenter?.getItemsBy(fetchOffSet)
        }
    }
    
    @objc func timerAction() {
        self.itemPresenter?.showToast(title: "Loading...", viewController: self)
    }
    
}

extension ItemListViewController: ItemView{
    func loadDataFromDB(items:[Item]?){
        if items?.count != 0 {
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
        }
        items?.forEach({ item in
            self.items.append(item)
        })
        itemListTableView.reloadData()
    }
}
