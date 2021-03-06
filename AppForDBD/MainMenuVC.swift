//
//  ViewController.swift
//  AppForDBD
//
//  Created by Dilara Şimşek on 11.04.2022.
//

import UIKit
import Alamofire




class MainMenuVC: UIViewController {
    
    @IBOutlet weak var lblKiller: UILabel!
    
    @IBOutlet weak var lblSurvivor: UILabel!
    
    @IBOutlet weak var collectionViewSurvivor: UICollectionView!
    
    @IBOutlet weak var collectionViewCurrency: UICollectionView!
    @IBOutlet weak var collectionViewKiller: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("deneme")
        
        navigationItem.backBarButtonItem?.isEnabled = false
        // Do any additional setup after loading the view.
        
        getData()
        
        getKillerData()
        
        getCurrencyDetail()
        
        effectToWidgets(label: lblKiller)
        effectToWidgets(label: lblSurvivor)
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
    
    
    func effectToWidgets(label: UILabel){
        
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.layer.shadowOpacity = 9.0
        label.layer.shadowRadius = 3.0
        
        
    }
    
    func getCurrencyDetail() {
        
        Network.sendRequestCurrency(Services.SERVICE_BASE_URL+Services.CURRENCIES, completionHandler: { response_detail in
            
            allCurrencyDetail.removeAll()
            
            for i in response_detail {
                
                allCurrencyDetail.append(CurrencyModel(_id: i.id, name: i.nameCurrency, icon: i.iconCurrency)
                )
            }
            
            self.collectionViewCurrency.reloadData()
            print("currencyname:\(allCurrencyDetail[0]._id)")
            
        })
    }
    
    
    func getKillerData() {
        Network.sendRequestKiller(Services.SERVICE_BASE_URL+Services.KILLERS, completionHandler: { response_detail in
            
            allKillerModel.removeAll()
            
            for i in response_detail {
                
                allKillerModel.append(
                    KillerModel(id: i._id, name: i.name,
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
            
        })
        
    }

    func getData(){
        
        
        Network.sendRequest(Services.SERVICE_BASE_URL+Services.SURVIVORS, completionHandler: { response_detail in
            
            allSurvivorModel.removeAll()
            
            for i in response_detail {
                
                allSurvivorModel.append(
                    SurvivorModel(id: i._id,
                                  name: i.name,
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


extension MainMenuVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewSurvivor {
            return allSurvivorModel.count
        } else if collectionView == collectionViewKiller{
            return allKillerModel.count
        } else {
            return allCurrencyDetail.count
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewSurvivor.dequeueReusableCell(withReuseIdentifier: "cellcvc", for: indexPath) as! SurvivorCVC
        
        let cellCurrency = collectionViewCurrency.dequeueReusableCell(withReuseIdentifier: "cellCurrency", for: indexPath) as! CurrenciesCVC
        
        
        
        if collectionView == collectionViewSurvivor {
            
            
            let url = URL(string: allSurvivorModel[indexPath.row].icon.preview_portrait)
            //print("url: \(url)")
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        cell.imgView.image = UIImage(data: data)
                        
                        //cell.imgView.layer.cornerRadius = cell.imgView.bounds.width / 2
                        //cell.imgView.layer.borderWidth = 3
                        //cell.imgView.layer.borderColor = UIColor.white.cgColor
                        cell.imgView.layer.shadowColor = UIColor.white.cgColor
                        cell.imgView.clipsToBounds = false
                        cell.imgView.layer.shadowOpacity = 1
                        cell.imgView.layer.shadowOffset = CGSize.zero
                        cell.imgView.layer.shadowRadius = 10
                        cell.imgView.layer.shadowPath = UIBezierPath(roundedRect: cell.imgView.bounds, cornerRadius: 10).cgPath

                    }
            }
            }
            
            
            cell.lblName.text = allSurvivorModel[indexPath.row].name
            
            effectToWidgets(label: cell.lblName)
            
            //cell.lblName.layer.borderWidth = 2
            //cell.lblName.layer.borderColor = UIColor.white.cgColor
            //cell.lblName.layer.cornerRadius = 15
            cell.lblName.layer.masksToBounds = true
            
            
            
            return cell
        } else if collectionView == collectionViewKiller{
            let url = URL(string: allKillerModel[indexPath.row].icon.preview_portrait)
            //print("url: \(url)")
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        cell.imgView.image = UIImage(data: data)
                        cell.imgView.layer.shadowColor = UIColor.white.cgColor
                        cell.imgView.clipsToBounds = false
                        cell.imgView.layer.shadowOpacity = 1
                        cell.imgView.layer.shadowOffset = CGSize.zero
                        cell.imgView.layer.shadowRadius = 10
                        cell.imgView.layer.shadowPath = UIBezierPath(roundedRect: cell.imgView.bounds, cornerRadius: 10).cgPath

                    }
            }
            }
            
            cell.lblName.text = allKillerModel[indexPath.row].name
            effectToWidgets(label: cell.lblName)
            
            return cell
        } else {
            
            
            let url = URL(string: allCurrencyDetail[indexPath.row].icon)
            //print("url: \(url)")
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        cellCurrency.imgViewCurrency.image = UIImage(data: data)
                        
                        //cell.imgView.layer.cornerRadius = cell.imgView.bounds.width / 2
                        //cell.imgView.layer.borderWidth = 3
                        //cell.imgView.layer.borderColor = UIColor.white.cgColor
                        cellCurrency.imgViewCurrency.layer.shadowColor = UIColor.white.cgColor
                        cellCurrency.imgViewCurrency.clipsToBounds = false
                        cellCurrency.imgViewCurrency.layer.shadowOpacity = 1
                        cellCurrency.imgViewCurrency.layer.shadowOffset = CGSize.zero
                        cellCurrency.imgViewCurrency.layer.shadowRadius = 10
                        cellCurrency.imgViewCurrency.layer.shadowPath = UIBezierPath(roundedRect: cellCurrency.imgViewCurrency.bounds, cornerRadius: 10).cgPath

                    }
            }
            }
            
            cellCurrency.lblCurrency.text = allCurrencyDetail[indexPath.row].name
            effectToWidgets(label: cellCurrency.lblCurrency)
            
            return cellCurrency
        }
        

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewSurvivor {
            
            let detailPage = Storyboards.main.instantiateViewController(withIdentifier: "DetailPageVC") as! DetailPageVC
            
            detailPage.detailID = allSurvivorModel[indexPath.row].id
            detailPage.detailType = .survivor
            detailPage.detailName = allSurvivorModel[indexPath.row].name
            self.navigationController?.pushViewController(detailPage, animated: true)
            
        } else if collectionView == collectionViewKiller{
            
            let detailPage = Storyboards.main.instantiateViewController(withIdentifier: "DetailPageVC") as! DetailPageVC
            
            detailPage.detailID = allKillerModel[indexPath.row].id
            detailPage.detailType = .killer
            detailPage.detailName = allKillerModel[indexPath.row].name
            self.navigationController?.pushViewController(detailPage, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == collectionViewSurvivor {
            
            return CGSize(width: 120, height: 120)
        } else if collectionView == collectionViewKiller{
            return CGSize(width: 120, height: 120)
        } else {
            return CGSize(width: 250, height: 250)
        }

    }
    
    
    
}





