//
//  SelectedResultDescriptionVC.swift
//  SearchWithWikipedia
//
//  Created by Vipul Kumar on 15/03/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import UIKit

class SelectedResultDescriptionVC: UIViewController {

    @IBOutlet weak var infoTableView: UITableView!
    
    let searchVM = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
    }
}

extension SelectedResultDescriptionVC {
    
    private func initialSetup() {
        
        self.searchVM.getResultDetialsOf(text: "")
        
        self.title = "Details"
        self.searchVM.observeViewModelChanges = self
        self.infoTableView.register(UINib(nibName: "InformationTableCell", bundle: nil), forCellReuseIdentifier: "InformationTableCell")
        self.infoTableView.dataSource = self
        self.infoTableView.delegate = self
    }
}

extension SelectedResultDescriptionVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _ = self.searchVM.resultDetails {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 320))
            let imageToShow = UIImageView(frame: CGRect(x: tableView.frame.width / 2 - 100, y: 16, width: 200, height: 300))
            let representLetterLabel = UILabel(frame: imageToShow.frame)
            
            imageToShow.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            imageToShow.contentMode = .scaleToFill
            imageToShow.clipsToBounds = true
            imageToShow.layer.cornerRadius = 5
            
            representLetterLabel.font = UIFont.systemFont(ofSize: 50, weight: .bold)
            representLetterLabel.textColor = UIColor.white
            representLetterLabel.text = ""
            representLetterLabel.isHidden = true
            representLetterLabel.textAlignment = .center
            representLetterLabel.clipsToBounds = true
            representLetterLabel.layer.cornerRadius = 5
            
            cell.selectionStyle = .none
            cell.addSubview(imageToShow)
            cell.addSubview(representLetterLabel)
            cell.layoutIfNeeded()
            
            if let details = self.searchVM.resultDetails {
                imageToShow.setImage(with: URL(string: details.source), placeholderImage: nil)
                
                if let page = self.searchVM.currentPage {
                    representLetterLabel.isHidden = !details.source.isEmpty
                    representLetterLabel.text = page.representedLetters
                    representLetterLabel.backgroundColor = page.ranomColor
                }
            }
            
            return cell
        
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformationTableCell", for: indexPath) as? InformationTableCell else {
                fatalError("InformationTableCell not found!")
            }
            
            if let resultDetails = self.searchVM.resultDetails {
                cell.loaData(details: resultDetails)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 320 : UITableView.automaticDimension
    }
}

extension SelectedResultDescriptionVC: ObserveViewModelChanges {
    
    func viewModelUpdated() {
        DispatchQueue.main.async {
            self.infoTableView.reloadData()
        }
    }
}
