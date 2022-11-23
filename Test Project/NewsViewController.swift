//
//  NewsViewController.swift
//  Test Project
//
//  Created by Alen Akif on 15.11.22..
//

import Foundation
import UIKit




enum Section: String, CaseIterable {
  case listed
  
}

class NewsViewController: UITableViewController, XMLParserDelegate{
    
    
    
    @IBSegueAction func showHeadDetailView(_ coder: NSCoder) -> DetailsNewsController? {
        let vest = news[0]
        return DetailsNewsController(coder: coder,news: vest)
    }
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailsNewsController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("Nothing selected")
        }
        let vest = news[indexPath.row]
        
        return DetailsNewsController(coder: coder,news: vest)
    }
    
    var news: [News] = []
    var elementName: String = String()
    var newsTitle = String()
    var imageUrl = String()
    var starterUrl = String("https://cdn.ttweb.net/News/images/")
    var smallImgEndUrl = String(".jpg?preset=w220_q40")
    var largeImgEndUrl = String(".jpg?preset=w320_q50")
    var rotatedImgUrl = String(".jpg?preset=w800_q70")
    var urlNews = String("https://www.teletrader.rs/downloads/tt_news_list.xml")
    var username = String("android_tt")
    var password = String("Sk3M!@p9e")
    var broj = 20.0
    @objc func ispis(){
        print("caoo")
        broj+=2
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //var gameTimer: Timer?
        //gameTimer = Timer.scheduledTimer(timeInterval: broj, target: self, selector: #selector(ispis), userInfo: nil, repeats: true)
        
        
        let url = URL(string: urlNews)
        let request = URLRequest(url: url!)
//        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let userPasswordString = "\(username):\(password)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: .init(rawValue: 0))
        let authString = "Basic \(base64EncodedCredential)"
        
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
        }
        task.resume()
        
           /*let task = URLSession.shared.dataTask(with: URL(string: urlNews)!) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }

            let parser = XMLParser(data: data)
            parser.delegate = self
             parser.parse()
                
            
        }
        task.resume()
*/
        
        
        /*if let path = Bundle.main.url(forResource: "News", withExtension: "xml") {
                if let parser = XMLParser(contentsOf: path) {
                    parser.delegate = self
                    parser.parse()
                }
        }*/
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       news.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeadNewsCell", for: indexPath) as! HeadNewsCell
            let vest = news[indexPath.row]
            cell.titelLabel?.text = vest.title
            
            if UIApplication.shared.statusBarOrientation.isLandscape {
                if let data = try? Data(contentsOf: URL(string: vest.rotatedImageUrl)!) {
                    // Create Image and Update Image View
                    cell.newsImageView.image = UIImage(data: data)
                    
                    
                }
            } else {
                if let data = try? Data(contentsOf: URL(string: vest.largeImgUrl)!) {
                    // Create Image and Update Image View
                    cell.newsImageView.image = UIImage(data: data)
                    
                }
                       
            }
            
            
            
            
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            let vest = news[indexPath.row]
            
            cell.newsTitleLabel?.text = vest.title
            if let data = try? Data(contentsOf: URL(string: vest.smallImageUrl)!) {
                // Create Image and Update Image View
                cell.newsSmallImageView.image = UIImage(data: data)
                
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row==0 ? 240 : 120
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "NewsArticle" {
            newsTitle = String()
            imageUrl = String()
            
        }

        self.elementName = elementName
    }

    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "NewsArticle" {
            let finalUrlSml = starterUrl + imageUrl + smallImgEndUrl
            let finalUrlLrg = starterUrl + imageUrl + largeImgEndUrl
            let finalUrlRt = starterUrl + imageUrl + rotatedImgUrl
            let new = News(title: newsTitle,largeImgUrl: finalUrlLrg,smallImageUrl: finalUrlSml,rotatedImageUrl: finalUrlRt)
           
            
            
            
            news.append(new)
        }
        if elementName == "Result" {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "Headline" {
                newsTitle += data
            } else if self.elementName == "ImageID" {
                 imageUrl += data
            }
        }
    }
    
}

