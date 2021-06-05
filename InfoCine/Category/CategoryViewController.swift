//
//  CategoryViewController.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryViewController: UIViewController ,UISearchResultsUpdating, UISearchBarDelegate, Storyboarded {
    
    
    
    @IBOutlet weak var categoryTableView : UITableView!

    let viewModel = CategoryViewModel()
    
    
    override func viewDidLoad() {
        
        viewModel.categorys.bind(to: self.categoryTableView.rx.items(cellIdentifier: "categoryCell", cellType: CategoryTableViewCell.self)) {row, model, cell  in
            cell.titleLabel?.text = model.title
        }.disposed(by: self.viewModel.disposeBag)
        
        categoryTableView.rx.modelSelected(CategoryModel.self).subscribe(onNext : { choice in
            self.viewModel.selectCategory(with: choice)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.viewModel.disposeBag)
        
        categoryTableView.tableFooterView = UIView()
        categoryTableView
            .rx.setDelegate(self)
            .disposed(by: self.viewModel.disposeBag)
        
        viewModel.fetchCategoryList()
    }
   
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let count = viewModel.categorys.value.count
            return tableView.frame.height / CGFloat(count)
        }
}
