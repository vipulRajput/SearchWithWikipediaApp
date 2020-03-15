//
//  ResultsVC.swift
//  SearchWithWikipedia
//
//  Created by Vipul Kumar on 15/03/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import UIKit
import Lottie

class ResultsVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var photosTableView: UITableView!
    @IBOutlet weak var lottieContainerView: UIView!
    
    let searchVM = SearchViewModel()
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.animationView.loopMode = LottieLoopMode.loop
        self.animationView.play()
    }
}

extension ResultsVC {
    
    private func initialSetup() {
        
        self.title = "Search Results"
        
        self.observeViewModelChanges()
        
        self.searchTextField.clipsToBounds = true
        self.searchTextField.delegate = self
        self.searchTextField.layer.cornerRadius = 5
        self.searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.searchTextField.layer.borderWidth = 1
        self.searchTextField.returnKeyType = .done
        self.searchTextField.autocorrectionType = .no
        self.searchTextField.clearButtonMode = .whileEditing
        self.searchTextField.setLeftPaddingPoints(16)
        self.searchTextField.addTarget(self, action: #selector(searchTextFieldEditingChanded), for: .editingChanged)
        
        self.photosTableView.separatorInset =  UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.photosTableView.tableFooterView = UIView()
        self.photosTableView.keyboardDismissMode = .onDrag
        self.photosTableView.register(UINib(nibName: "ResultTableCell", bundle: nil), forCellReuseIdentifier: "ResultTableCell")
        self.photosTableView.dataSource = self
        self.photosTableView.delegate = self
        
        self.lottieContainerView.isHidden = true        
        let animation = Animation.named("13525-empty")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        self.lottieContainerView.addSubview(animationView)
    }
    
    @objc private func searchTextFieldEditingChanded(_ sender: UITextField) {
        
        if let enteredText = sender.text, enteredText.count >= 3 {
            self.searchVM.debounce(seconds: 0.20) { [weak self] in
                self?.searchVM.getResultsOf(text: enteredText)
            }
        } else {
            self.searchVM.searchResult = nil
            self.removeAllData()
        }
    }
    
    private func observeViewModelChanges() {
        self.searchVM.observeViewModelChanges = self
    }
    
    private func bindData() {
        DispatchQueue.main.async {
            if let enteredText = self.searchTextField.text, !enteredText.isEmpty {
                self.photosTableView.reloadData()
                
                if let searchedData = self.searchVM.searchResult {
                    self.lottieContainerView.isHidden = !searchedData.pages.isEmpty
                } else {
                    self.lottieContainerView.isHidden = true
                }
                
            } else {
                self.lottieContainerView.isHidden = true
                self.removeAllData()
            }
        }
    }
    
    private func removeAllData() {
        
        self.searchVM.searchResult = nil
        DispatchQueue.main.async {
            self.photosTableView.reloadData()
        }
    }
}

extension ResultsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let searchedData = self.searchVM.searchResult {
            return searchedData.pages.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell", for: indexPath) as? ResultTableCell else {
            fatalError("ResultTableCell not found!")
        }
        
        if let searchedData = self.searchVM.searchResult, searchedData.pages.count > indexPath.row {
            cell.load(result: searchedData.pages[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectedResultDescriptionVC") as! SelectedResultDescriptionVC
        obj.searchVM.currentPage = self.searchVM.searchResult!.pages[indexPath.row]
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

extension ResultsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == 0 && string == " " {
            return false
        }
        if range.length == 1 {
            return true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        self.searchVM.searchResult = nil
        self.bindData()
        return true
    }
}

extension ResultsVC: ObserveViewModelChanges {
    
    func viewModelUpdated() {
        
        self.bindData()
    }
}
