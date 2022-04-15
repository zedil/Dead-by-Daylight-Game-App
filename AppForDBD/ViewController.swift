//
//  ViewController.swift
//  AppForDBD
//
//  Created by Dilara Şimşek on 11.04.2022.
//

import UIKit
import Alamofire




class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionViewSurvivor: UICollectionView!
    
    @IBOutlet weak var collectionViewKiller: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("deneme")
        // Do any additional setup after loading the view.
        
        getData()
        
        getKillerData()
    }
    

    /*
    func getData() {
        let url = "https://dbd-api.herokuapp.com/survivors"
        //let para
        AF.request(url, method: .get).responseJSON { (response) in

            switch response.result {
            case .success(let data):

                do {

                    let survivors = try JSONDecoder().decode([Survivor].self, from: response.data!)
                    
                    print("detail: \(survivors[0].name)")
                    print("detail2: \(survivors[0].icon)")
                    print("perk: \(survivors[0].perks[0])")
                  
                    

                }
                catch {print(error)}

            case .failure(let error):
                print (error)
            }
        }
    }
    */
    
    
    func getKillerData() {
        Network.sendRequestKiller(Services.SERVICE_BASE_URL+Services.KILLERS, completionHandler: { response_detail in
            
            allKillerModel.removeAll()
            
            for i in response_detail {
                
                allKillerModel.append(
                    KillerModel(name: i.name,
                                  full_name: i.full_name,
                                  gender: i.gender,
                                  nationality: i.nationality,
                                  overview: i.overview,
                                  difficulty: i.difficulty,
                                  icon: IconKillerModel(portrait: i.icon.portrait,
                                              preview_portrait: i.icon.preview_portrait,
                                              shop_background: i.icon.shop_background),
                                  perks: i.perks)
                )
            }
            
            self.collectionViewKiller.reloadData()
            
            print("icon2: \(allKillerModel[0].icon.preview_portrait)")
            print("name: \(allKillerModel[0].name)")
        })
        
    }

    func getData(){
        
        
        Network.sendRequest(Services.SERVICE_BASE_URL+Services.SURVIVORS, completionHandler: { response_detail in
            
            allSurvivorModel.removeAll()
            
            for i in response_detail {
                
                allSurvivorModel.append(
                    SurvivorModel(name: i.name,
                                  full_name: i.full_name,
                                  gender: i.gender,
                                  role: i.role,
                                  nationality: i.nationality,
                                  overview: i.overview,
                                  difficulty: i.difficulty,
                                  icon: IconModel(portrait: i.icon.portrait,
                                              preview_portrait: i.icon.preview_portrait,
                                              shop_background: i.icon.shop_background),
                                  perks: i.perks)
                )
            }
            
            print("icon2: \(allSurvivorModel[0].icon.preview_portrait)")
            self.collectionViewSurvivor.reloadData()
            
        })
        
    }

    
    


}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewSurvivor {
            return allSurvivorModel.count
        } else {
            return allKillerModel.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewSurvivor.dequeueReusableCell(withReuseIdentifier: "cellcvc", for: indexPath) as! SurvivorCVC
        
        
        
        if collectionView == collectionViewSurvivor {
            
            
            let url = URL(string: allSurvivorModel[indexPath.row].icon.preview_portrait)
            //print("url: \(url)")
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        cell.imgView.image = UIImage(data: data)
                        
                        cell.imgView.layer.cornerRadius = cell.imgView.bounds.width / 2
                        cell.imgView.layer.borderWidth = 3
                        cell.imgView.layer.borderColor = UIColor.white.cgColor

                    }
            }
            }
            
            return cell
        } else {
            let url = URL(string: allKillerModel[indexPath.row].icon.preview_portrait)
            //print("url: \(url)")
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        cell.imgView.image = UIImage(data: data)
                        
                        cell.imgView.layer.cornerRadius = cell.imgView.bounds.width / 2
                        cell.imgView.layer.borderWidth = 3
                        cell.imgView.layer.borderColor = UIColor.white.cgColor

                    }
            }
            }
            
            return cell
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == collectionViewSurvivor {
            
            return CGSize(width: 120, height: 120)
        } else {
            return CGSize(width: 120, height: 120)
        }

    }
    
    
    
}
