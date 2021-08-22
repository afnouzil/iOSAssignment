//
//  CartListViewController.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/18/21.
//

import UIKit

class CartListViewController: UIViewController {

    @IBOutlet var cartListTableView: UITableView!
    
    @IBOutlet var emptyImageView: UIImageView!
    private var cartItemsArray = [Item]()
    var presenter: CartViewPresentation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        displayData()
    }
    
    func initialSetup(){
        
        self.title = Constants.cartTitle
        cartListTableView.register(UINib(nibName: Identifier.ItemTableViewCell, bundle: nil), forCellReuseIdentifier: Identifier.itemCellIdentifier)

    }
    
    func displayData(){
        guard let presenter = presenter else {
            return
        }
        guard let items = presenter.fetchItem() else { return }
        presenter.loadDataFromDB(items: items)
    }
    
    func showEmptyCartImage(_ value: Bool){
        emptyImageView.isHidden = !value
        cartListTableView.isHidden = value
        if value{
            emptyImageView.sd_setImage(with: URL(string: Constants.emptyCartUrl), placeholderImage: UIImage(named: ""))
        }
    }

}
extension CartListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartItemsArray.count == 0{
           showEmptyCartImage(true)
        }
        return cartItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.itemCellIdentifier) as? ItemTableViewCell else{ return UITableViewCell() }
        cell.itemDescription.text = cartItemsArray[indexPath.row].description
        cell.itemTitle.text = cartItemsArray[indexPath.row].name
        cell.itemPrice.text = " ₹ \(cartItemsArray[indexPath.row].price)"
        let imageUrl = cartItemsArray[indexPath.row].image.replacingOccurrences(of: "http", with: "https")
        cell.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: ""))
        cell.addToCartButton.setImage(UIImage(systemName: "delete.right.fill"), for: .normal)
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(deleteButtonPressed(button:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func deleteButtonPressed(button:UIButton){
        let pressedIndex = button.tag
        let cartManager = CartManager()
        let item = cartItemsArray[pressedIndex]
        let isDeleted = cartManager.deleteItem(id: item.id)
        if isDeleted{
            cartItemsArray.remove(at: pressedIndex)
            cartListTableView.reloadData()
        }
    }

}

extension CartListViewController: CartView{
    func loadDataFromDB(items: [Item]?) {
        cartItemsArray.removeAll()
        if !(self.presenter?.isItemDBEmpty())! {
            guard let items = self.presenter?.fetchItem() else {
                return
            }
            cartItemsArray = items
            cartListTableView.reloadData()
        }

    }
    
}
