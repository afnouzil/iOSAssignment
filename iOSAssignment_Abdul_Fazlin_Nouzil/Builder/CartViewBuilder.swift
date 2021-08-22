//
//  CartViewBuilder.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/22/21.
//

import UIKit

protocol CartView{
    func loadDataFromDB(items:[Item]?)
}

protocol CartUseCase {
    var cartManager: CartManager? { get }
    func fetchItem() -> [Item]?
    func isItemDBEmpty()->Bool
    func fetchItem(byIdentifer id: String) -> Bool
    func createItem(item: Item)

}
class CartInteractor: CartUseCase{

    var cartManager: CartManager?

    init(cartManager: CartManager = CartManager() ) {
        self.cartManager = cartManager
    }

    func fetchItem() -> [Item]?{
        cartManager?.fetchItem()
    }

    func isItemDBEmpty()->Bool{
        guard let itemsArray = fetchItem() else { return true }
        if itemsArray.count != 0 {
            return false
        }
        return true
    }
    func fetchItem(byIdentifer id: String) -> Bool{
        cartManager!.fetchItem(byIdentifier: id)
    }
    func createItem(item: Item){
        cartManager?.createCartItem(item: item)
    }

}

protocol CartViewPresentation {
    func fetchItem() ->[Item]?
    func isItemDBEmpty()->Bool
    func loadDataFromDB(items:[Item]?)
    func fetchItem(byIdentifer id: String) -> Bool
    func addItemToCart(_ item:Item, viewController:UIViewController)

}

class CartViewPresentor: CartViewPresentation{
    var router: CartWireFrame?
    var interactor: CartUseCase?
    var view: CartView?

    func fetchItem() -> [Item]?{
        interactor?.fetchItem()
    }
    
    func isItemDBEmpty()->Bool{
        return interactor!.isItemDBEmpty()
    }
    func loadDataFromDB(items:[Item]?){
        view?.loadDataFromDB(items: items)
    }
    func fetchItem(byIdentifer id: String) -> Bool
    {
        interactor!.fetchItem(byIdentifer: id)
    }
    
    func addItemToCart(_ item:Item, viewController:UIViewController){
        let isItemFound = interactor!.fetchItem(byIdentifer: item.id)
        if isItemFound {
            router?.showToast(title: "item is already added to cart")
        }else{
            interactor?.createItem(item: item)
            router?.showToast(title: "item added to cart successfully")

        }
    }
}

protocol CartWireFrame {
    var viewController: UIViewController? { get}
    func showToast(title: String)
}

class CartViewRouter: UIViewController, CartWireFrame{
    
    var viewController: UIViewController?
    func showToast(title: String){
        let messageVC = UIAlertController(title: title, message: "" , preferredStyle: .actionSheet)
        viewController?.navigationController!.present(messageVC, animated: true) {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                                    messageVC.dismiss(animated: true, completion: nil)})}
    }
}


class CartViewBuilder {
    static func assembleModule() -> UIViewController{

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let view = storyboard.instantiateViewController(identifier: "cartListViewController") as? CartListViewController else { return UIViewController()}

        let interactor = CartInteractor()
        let presenter = CartViewPresentor()
        let router = CartViewRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        router.viewController = view

        return view
    }
}
