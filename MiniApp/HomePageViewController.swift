//
//  HomePageViewController.swift
//  MiniApp
//
//  Created by Akanksha Dhyani on 11/02/19.
//  Copyright © 2019 Akanksha Dhyani. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Poi
import Kingfisher

class HomePageViewController: UIViewController, PoiViewDataSource, PoiViewDelegate {
   
    @IBOutlet weak var poiView: PoiView!
    var serviceObject = Service()
    var sampleCards = [UIView]()
    var allPets: [PetDetails] = []
    var cardCount = 0
    
    
    func retrieveData() {
        self.serviceObject.getType(append: "pets") { (petsObject) in
            if petsObject.response?.status?.code == 200 {
                self.allPets = (petsObject.response?.data?.pets)!
                self.cardCount = self.allPets.count
                for index in (0..<self.cardCount) {
                    let url = URL(string: self.allPets[index].image!)!
                    let petPhoto = UIImageView()
                    petPhoto.kf.setImage(with: url)
                    self.sampleCards.append(petPhoto)
                }
                self.poiView.dataSource = self
                self.poiView.delegate = self
            }
            else {
                
            }
        }
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
    retrieveData()
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfCards(_ poi: PoiView) -> Int {
        return cardCount
    }
    
    func poi(_ poi: PoiView, viewForCardAt index: Int) -> UIView {
        return sampleCards[index]
    }
    
    func poi(_ poi: PoiView, viewForCardOverlayFor direction: SwipeDirection) -> UIImageView? {
        switch direction {
        case .right:
            return UIImageView(image: UIImage(named: "like"))
        case .left:
            return UIImageView(image: UIImage(named: "dislike"))
        }
    }
    func poi(_ poi: PoiView, didSwipeCardAt: Int, in direction: SwipeDirection) {
        let petId = self.allPets[didSwipeCardAt-1].pid!
        switch direction {
        case .right:
            requestServer(change: true, for: petId)
        case .left:
            requestServer(change: false, for: petId)
        }
    }
    func requestServer(change value: Bool, for petId: String) {
        serviceObject.putType(append: "pets/likes/"+petId, put: value) { (responseObject) in
            if responseObject.response?.status?.code == 200 {
                print("Likes Updated")
            }
            else {
                print("Couldn't update!")
            }
        }
    }
    func poi(_ poi: PoiView, runOutOfCardAt: Int, in direction: SwipeDirection) {
        print("last")
    }
    @IBAction func rightSwipe(_ sender: Any) {
        poiView.swipeCurrentCard(to: .right)
    }
    @IBAction func leftSwipe(_ sender: UIButton) {
        poiView.swipeCurrentCard(to: .left)
    }
    @IBAction func onUndo(_ sender: UIButton) {
       poiView.undo()
    }
@IBAction func logoutPress(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "usertoken")
        self.performSegue(withIdentifier: "logout", sender: self)
    }
}
