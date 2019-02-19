//
//  LikesViewController.swift
//  MiniApp
//
//  Created by Akanksha Dhyani on 13/02/19.
//  Copyright © 2019 Akanksha Dhyani. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import CoreGraphics

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petDesc: UILabel!
}
class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    var likedPetsName: [String] = []
    var filteredPetNames: [String] = []
    var resultSearchController = UISearchController()
    var likedPets = [PetDetails]()
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllLikedPets()
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.black
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.backgroundColor = UIColor.clear
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        self.tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        filteredPetNames.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (likedPetsName as NSArray).filtered(using: searchPredicate)
        // swiftlint:disable force_cast
        filteredPetNames = array as! [String]
        // swiftlint:enable force_cast
         self.tableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        // swiftlint:enable force_cast
        if self.resultSearchController.isActive {
            cell.petName.text = filteredPetNames[indexPath.row]
            for item in likedPets {
                if filteredPetNames[indexPath.row] == item.name {
                    cell.petImage.kf.setImage(with: URL(string: item.image!))
                    cell.petDesc.text = item.desc!
                    break
                }
            }
        } else {
            cell.petName.text = self.likedPets[indexPath.row].name
            cell.petImage.kf.setImage(with: URL(string: self.likedPets[indexPath.row].image!))
            cell.petDesc.text = self.likedPets[indexPath.row].desc
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            return self.filteredPetNames.count
        } else  {
            return self.likedPets.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
    }
    func getAllLikedPets() {
        let serviceObject = Service()
        serviceObject.getType(append: "pets/likes"){ (petsObject) in
            self.likedPets = (petsObject.response?.data?.pets)!
            if self.likedPets.count >= 1 {
                for item in self.likedPets {
                    self.likedPetsName.append(item.name!)
                }
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.tableFooterView = UIView(frame: CGRect.zero)
            }
            else {
                let viewWidth = self.tableView.frame.size.width
                let viewHeight = self.tableView.frame.size.height
                let myNewView=UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
                myNewView.backgroundColor=UIColor.white
                self.tableView.addSubview(myNewView)
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
                label.center = CGPoint(x: viewWidth/2, y: viewHeight/3)
                label.textAlignment = NSTextAlignment.center
                label.text = "Oops! No pets to show in your likes."
                self.view.addSubview(label)
            }
        }
    }
}
