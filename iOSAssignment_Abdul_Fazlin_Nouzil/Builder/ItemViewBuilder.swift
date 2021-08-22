//
//  ItemViewBuilder.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/21/21.
//

import UIKit

protocol ItemView: AnyObject{
    func loadDataFromDB(items:[Item]?)
}

protocol ItemUseCase: AnyObject {
    var itemManager: ItemManager? { get }
    func createItem(item: Item)
    func getItemsBy(_ offset: Int)->[Item]?
    func fetchItem() -> [Item]?
    func getItemsAndSaveToDB(completion:(([Item]?)->())?)
    func isItemDBEmpty()->Bool

}
class ItemInteractor: ItemUseCase{
    
    var itemManager: ItemManager?
    var cartManager: CartManager?

    init(itemManager: ItemManager = ItemManager(), cartManager: CartManager = CartManager() ) {
        self.itemManager = itemManager
        self.cartManager = cartManager
    }
    
    func createItem(item: Item) {
        itemManager?.createItem(item: item)
    }
    
    func getItemsBy(_ offset: Int)->[Item]?{
        itemManager?.getItems(offset)
    }
    
    func fetchItem() -> [Item]?{
        itemManager?.fetchItem()
    }
    
    func getItemsAndSaveToDB(completion:(([Item]?)->())?){
        
        guard let url = URL(string: Constants.baseUrl) else { return }
        
        HTTPUtility.shared.getData(requestUrl:url , resultType: Array<Item>.self) { (items) in
            _ = items.map {[weak self] items in
                DispatchQueue.main.async {
                    if items?.count != 0{
                        items!.forEach({ item in
                            self?.createItem(item: item)
                        })
                    }
                    completion?(items)
                }
            }
        }
    }
    


    func isItemDBEmpty()->Bool{
        guard let itemsArray = fetchItem() else { return true }
        if itemsArray.count != 0 {
            return false
        }
        return true
    }

    
}

protocol ItemViewPresentation: AnyObject {
    
    var view: ItemView? {get}
    var router: ItemWireFrame? {get}
    var interactor: ItemUseCase? {get}
    
    // View
    

    //Interactor
    func getItemsAndSaveToDB()
    func createItem(item: Item)
    func getItemsBy(_ offset: Int)
    func fetchItem() -> [Item]?
    func isItemDBEmpty()->Bool

    // Router
    func showToast(title: String,viewController: UIViewController)
    func gotoCartListViewController(viewController: UIViewController)
}

class ItemViewPresentor: ItemViewPresentation{
    
    var router: ItemWireFrame?
    var interactor: ItemUseCase?
    weak var view: ItemView?
    
    // View
    
    //Interactor
    
    func getItemsAndSaveToDB(){
        
        interactor?.getItemsAndSaveToDB(completion: { items in
            if items?.count != 0{
                let itemsByOffset = self.interactor?.getItemsBy(0)
                self.view?.loadDataFromDB(items: itemsByOffset)
            }
            
        })
    }

    func createItem(item: Item)
    {
        interactor?.createItem(item: item)
    }
    
    func getItemsBy(_ offset: Int){
        let itemsByOffset = self.interactor?.getItemsBy(offset)
        self.view?.loadDataFromDB(items: itemsByOffset)
    }
    
    func fetchItem() -> [Item]?{
        interactor?.fetchItem()
    }
    func isItemDBEmpty()->Bool{
        return interactor!.isItemDBEmpty()
    }

    // Router

    func showToast(title: String,viewController: UIViewController){
        router?.showToast(title: title)
    }
    
    func gotoCartListViewController(viewController: UIViewController){
        router?.gotoCartListViewController()
    }

}

protocol ItemWireFrame {
    var viewController: UIViewController? { get}
    
    func showToast(title: String)
    func gotoCartListViewController()
}

class ItemViewRouter: UIViewController, ItemWireFrame{
    var viewController: UIViewController?
    
    func showToast(title: String){
        let messageVC = UIAlertController(title: title, message: "" , preferredStyle: .actionSheet)
        viewController?.navigationController!.present(messageVC, animated: true) {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                                    messageVC.dismiss(animated: true, completion: nil)})}
    }
    
    func gotoCartListViewController(){
        
        let cartListViewController = CartViewBuilder.assembleModule()
        viewController?.navigationController!.pushViewController(cartListViewController, animated: true)
    }

}


class ItemViewBuilder {
    static func assembleModule() -> UIViewController{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let view = storyboard.instantiateViewController(identifier: "itemListViewController") as? ItemListViewController else { return UIViewController()}
        
        let itemInteractor = ItemInteractor()
        let itemPresenter = ItemViewPresentor()
        let itemRouter = ItemViewRouter()

        let cartInteractor = CartInteractor()
        let cartPresenter = CartViewPresentor()
        let cartRouter = CartViewRouter()

        view.itemPresenter = itemPresenter
        itemPresenter.view = view
        itemPresenter.interactor = itemInteractor
        itemPresenter.router = itemRouter
        
        view.cartPresenter = cartPresenter
        cartPresenter.router = cartRouter
        cartPresenter.interactor = cartInteractor
        
        itemRouter.viewController = view
        cartRouter.viewController = view

        return view
    }
}
