//
//  AnalysisController.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-02-24.
//  Copyright © 2017 Koki. All rights reserved.
//

import Foundation
import UIKit

class AnalysisController: UITableViewController, UISearchBarDelegate,UISearchResultsUpdating {

    var date = [String]() //array variable of type string
    var skillName = [String]()
    var good_times = [String]()
    var ok_times = [String]()
    var bad_times = [String]()
    var textsearched = NSString() //searched text
    //search bar
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "breakin.jpeg")
        self.view.insertSubview(backgroundImage, at: 0)*/
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(AnalysisController.getDatas), for: UIControlEvents.valueChanged)
        let refleshtitle = "Swipe to update...";
        refreshControl?.attributedTitle = NSAttributedString(string: refleshtitle)
        
        self.getDatas()
        
        /*searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar//agregamos la barra en el header
        
        //barra de busqueda
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search skill"
        searchController.searchBar.tintColor = UIColor.gray
        searchController.searchBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        */

        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

    
    func getDatas(){
        //Remove the array to add new elements and prevent them from being repeated
        self.date.removeAll()
        self.skillName.removeAll()
        self.good_times.removeAll()
        self.ok_times.removeAll()
        self.bad_times.removeAll()
        //
        
        
        let key = "123456"
        let postString = "search=\(self.textsearched)&key=\(key)" //Data send post
        
        let url = URL(string: "http://headspinnerd.000webhostapp.com/bboying/search.php")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" //send type -> post method
        request.httpBody = postString.data(using: .utf8)// Concatenate my variables with utf8
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {//If there is an error, the function is terminated.
                print("Request failed \(error)")  // handle the erro
                return // break the code block
            }
            
            
            do { //creamos nuestro objeto json
                
                if let json = try JSONSerialization.jsonObject(with: data) as? [NSDictionary] {
                    
                    DispatchQueue.main.async {//proceso principal
                        for result in json {
                            let date = result["date"] as! String
                            let skillName = result["skillName"] as! String
                            let good_times = result["good_times"] as! String
                            let ok_times = result["ok_times"] as! String
                            let bad_times = result["bad_times"] as! String
                            
                            self.date.append(date)//empujamos los elementos a los array
                            self.skillName.append(skillName)
                            self.good_times.append(good_times)
                            self.ok_times.append(ok_times)
                            self.bad_times.append(bad_times)
                        }
                        self.refreshControl?.endRefreshing()//finalizar refreshcontrol
                        self.tableView.reloadData()//recargarme la tabla nuevamente
                    }
                }
                
            } catch let parseError {//manejamos el error
                print("error al parsear: \(parseError)")
                
                let responseString = String(data: data, encoding: .utf8)
                print("respuesta : \(responseString)")
            }
            }
            task.resume()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.skillName.count //equivalente numero de elementos en el array
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let analysiscell = tableView.dequeueReusableCell(withIdentifier: "analysiscell", for: indexPath) as! ShowAnalysis
        if ( indexPath.row % 2 == 0 ) {
            analysiscell.backgroundColor = UIColor(red: 200/255.5, green: 200/255.5, blue: 200/255.5, alpha: 0.2)
        } else {
            analysiscell.backgroundColor = UIColor(red: 150/255.5, green: 150/255.5, blue: 150/255.5, alpha: 0.2)
        }
        analysiscell.dateLabel.text = self.date[indexPath.row].description
        analysiscell.skillNameLabel.text = self.skillName[indexPath.row].description
        analysiscell.counterLabel.text = "\(self.good_times[indexPath.row].description)/\(self.ok_times[indexPath.row].description)/\(self.bad_times[indexPath.row].description)"
        
        return analysiscell
    }
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaisesDetalle") as! PaisesDetalle
        self.navigationController!.pushViewController(nextViewController, animated: true)
        
        nextViewController.id = self.idPais[indexPath.row].description as NSString
        nextViewController.nombre = self.nombrePais[indexPath.row].description as NSString
        nextViewController.estados = self.estadosPais[indexPath.row].description as NSString
        nextViewController.poblacion = self.poblacionPais[indexPath.row].description as NSString
        nextViewController.urlFoto = self.fotoUrlPais[indexPath.row].description as NSString
        
    }*/
    
    func updateSearchResults(for searchController: UISearchController) {
        print("text \(searchController.searchBar.text)")//debug
        self.textsearched = searchController.searchBar.text! as NSString
        self.getDatas()
    }

    
    


}
