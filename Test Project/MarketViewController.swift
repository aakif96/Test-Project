//
//  MarketViewController.swift
//  Test Project
//
//  Created by Alen Akif on 17.11.22..
//

import Foundation
import UIKit
class FirstHeaderView: UITableViewHeaderFooterView{
    static let reuseIdentifier = "\(FirstHeaderView.self)"
    @IBOutlet var nameHeaderLabel: UILabel!
    @IBOutlet var changeHeaderLabel: UILabel!
    @IBOutlet var lastHeaderLabel: UILabel!
}
class MarketViewController: UITableViewController, XMLParserDelegate{
    
    
    @IBSegueAction func showDetailsMarketOne(_ coder: NSCoder) -> DetailsMarketController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("Nothing selected")
        }
        let marketITem = displayItems[indexPath.row]
        
        let dmc = DetailsMarketController(coder: coder,marketItem: marketITem, mvc: self)
        controllerDict[marketITem.id] = dmc
        return dmc
    }
    
    
    @IBSegueAction func showDetailsMarketTwo(_ coder: NSCoder) -> DetailsMarketController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("Nothing selected")
        }
        let marketITem = displayItems[indexPath.row]
        let dmc = DetailsMarketController(coder: coder,marketItem: marketITem,mvc: self)
        controllerDict[marketITem.id] = dmc
        return dmc
    }
    
    @IBOutlet var changeBarButton: UIBarButtonItem!
    @IBOutlet var sortBarButton: UIBarButtonItem!
    @IBAction func sortFunction(_ sender: Any) {
        
        if sortStatus==SortStatus.DEFAULT {
            
            sortStatus = SortStatus.ASC
            
            
        }else if sortStatus == SortStatus.ASC{
            
            sortStatus = SortStatus.DSC
            
        }else if sortStatus == SortStatus.DSC{
            
            sortStatus = SortStatus.DEFAULT
          
        }
        UserDefaults.standard.set(sortStatus.rawValue, forKey: "sort_status")
        sortWrapperFunction()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func changeAction(_ sender: Any) {
        bidAsk = !bidAsk
        
        configurateButton()
        UserDefaults.standard.set(bidAsk, forKey: "bid_ask")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func sortWrapperFunction(){
        if sortStatus==SortStatus.ASC {
            displayItems.sort{
                $0.name < $1.name
                
            }
            
        }else if sortStatus == SortStatus.DSC{
            displayItems.sort{
                $0.name > $1.name
                
            }
            
        }else if sortStatus == SortStatus.DEFAULT{
            displayItems = marketsItems
            
        }
        configurateSortButton()
        
    }
    
   
    var urlMarkets = String("https://www.teletrader.rs/downloads/tt_symbol_list.xml")
    var username = String("android_tt")
    var password = String("Sk3M!@p9e")
    var marketsItems: [MarketsItem] = []
    var displayItems: [MarketsItem] = []
    var elementName: String = String()
    var itemID = String()
    var itemName = String()
    var itemTickerSymbol = String()
    var itemIsin = String()
    var itemCurrency = String()
    var itemStockExchangeName = String()
    var itemDecorativeName = String()
    var itemVolume = String()
    var itemDateTime = String()
    var itemChangePercent = String()
    var itemHigh = String()
    var itemLow = String()
    var itemBid = String()
    var itemAsk = String()
    
    var itemChange = String()
    var itemLast = String()
    var sortStatus = SortStatus.DEFAULT
    var bidAsk = false
    var reloadData = true
    var timerDict:[String:Timer] = [:]
    var controllerDict:[String:DetailsMarketController] = [:]
   
    
    func formatString(word:String) -> String{
        var broj = 0
        var result = ""
        var has = false
        for ch in word{
            if ch == "." || has{
                broj+=1
                has = true
            }
            
            result += String(ch)
            if broj == 3{
                return result
            }
        }
        return result
    }
    func configurateButton(){
        DispatchQueue.main.async {
            if self.bidAsk{
                self.changeBarButton.title = "Chg/Last"
            }else{
                self.changeBarButton.title = "Bid/Ask"
            }
        }
    }
    func configurateSortButton(){
        DispatchQueue.main.async {
            if self.sortStatus==SortStatus.ASC {
                
                
                self.sortBarButton.image = UIImage(systemName: "arrow.up")
                
            }else if self.sortStatus == SortStatus.DSC{
                
                
                self.sortBarButton.image = UIImage(systemName: "arrow.down")
            }else if self.sortStatus == SortStatus.DEFAULT{
                
                
                self.sortBarButton.image = UIImage(systemName: "arrow.up.arrow.down")
            }
        }
    }
    
    /*func loadItems(){
        
        do{
            if let data = UserDefaults.standard.data(forKey: "display") {
                displayItems = try JSONDecoder().decode([MarketsItem], from: data)
                
            }
        }catch let error {
            print("error encoding")
        }
        
    }
    func saveItems(){
        
        do {
            let data = try JSONEncoder().encode(displayItems)
            UserDefaults.standard.set(data, forKey: "display")
        }catch let error{
            print("error decodinc")
        }
        do {
            let data = try JSONEncoder().encode(marketsItems)
            UserDefaults.standard.set(data, forKey: "markets")
        }catch let error{
            print("error decodinc")
        }
        //UserDefaults.standard.set(displayItems, forKey: "display")
       // UserDefaults.standard.set(marketsItems, forKey: "markets")
    }*/
    
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        bidAsk = UserDefaults.standard.bool(forKey: "bid_ask")
        let ss = UserDefaults.standard.integer(forKey: "sort_status")
        sortStatus = SortStatus(rawValue: ss) ?? .DEFAULT
        configurateButton()
        
        
        uploadMarketItems()
       
        
        tableView.register(UINib(nibName: "\(FirstHeaderView.self)", bundle: nil), forHeaderFooterViewReuseIdentifier: FirstHeaderView.reuseIdentifier)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshTable), for: .valueChanged)
        self.refreshControl = refreshControl
        
        
       
    }
   
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FirstHeaderView.reuseIdentifier) as? FirstHeaderView else{ return nil}
        
        if bidAsk{
            
            headerView.changeHeaderLabel.text = "Bid/Ask"
            headerView.lastHeaderLabel.text = "High/Low"
        }else{
            headerView.changeHeaderLabel.text = "Change%"
            headerView.lastHeaderLabel.text = "Last"
        }
        return headerView
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == UITableViewCell.EditingStyle.delete{
                let pomoc = displayItems[indexPath.row]
                marketsItems.removeAll(where: {$0.name == pomoc.name})
                displayItems.remove(at: indexPath.row)
                timerDict.removeValue(forKey: pomoc.id)?.invalidate()
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if bidAsk {
            return 65
        }else{
            return UITableView.automaticDimension
        }
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let element = displayItems.remove(at: sourceIndexPath.row)
            displayItems.insert(element, at: destinationIndexPath.row)
        }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems.count
        
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if bidAsk{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HighLowCell", for: indexPath) as! HighLowCell
           
            
            
            let symbol = displayItems[indexPath.row]
            cell.nameLabel.text = symbol.name
            cell.BidLabel.text = String(symbol.bid)
            cell.askLabel.text = String(symbol.ask)
            cell.LowLabel.text = String(symbol.low)
            cell.highLabel.text = String(symbol.high)
            
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MarketsCell", for: indexPath) as! MarketCell
           
            
            
            let symbol = displayItems[indexPath.row]
            cell.nameLabel.text = symbol.name
            //cell.changeLabel.text = symbol.change
            cell.changeLabel.text = formatString(word: String(symbol.changePercent)) + "%"
            if symbol.changePercent > 0 {
                cell.changeLabel.textColor = .green
            }
            if symbol.changePercent < 0{
                cell.changeLabel.textColor = .red
            }
            if symbol.changePercent == 0{
                cell.changeLabel.textColor = .label
            }
            
            
            
            
            if symbol.color == 0{
                cell.lastLabel.backgroundColor = .green
            }else if symbol.color == 1{
                cell.lastLabel.backgroundColor = .red
            }else if symbol.color == 2{
                cell.lastLabel.backgroundColor = .none
            }
            cell.lastLabel.text = formatString(word: String(symbol.last))
            
            return cell
        }
        
        
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "Symbol" {
            itemID = attributeDict["id"]!
            itemName = attributeDict["name"]!
            itemTickerSymbol = attributeDict["tickerSymbol"]!
            itemIsin = attributeDict["isin"] ?? "0"
            itemCurrency = attributeDict["currency"]!
            itemStockExchangeName = attributeDict["stockExchangeName"]!
            itemDecorativeName = attributeDict["decorativeName"]!
            
            
        }else if elementName == "Quote"{
            itemChange = attributeDict["change"] ??  "0"
            itemVolume  = attributeDict["volume"] ?? "0"
            itemDateTime = attributeDict["dateTime"]!
            itemChangePercent = attributeDict["changePercent"] ?? "0"
            itemLast = attributeDict["last"]!
            itemBid = attributeDict["bid"] ?? "0"
            itemAsk = attributeDict["ask"] ?? "0"
            itemHigh = attributeDict["high"]!
            itemLow = attributeDict["low"]!
        }

        self.elementName = elementName
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Symbol" {
            let symbol = MarketsItem(id: itemID, name: itemName, ticketSymbol: itemTickerSymbol,isin: itemIsin,currency: itemCurrency,stockExchangeName: itemStockExchangeName,decorativeName: itemDecorativeName,last: Double(itemLast)!,high: Double(itemHigh)!,low: Double(itemLow)!,bid: Double(itemBid)!,ask: Double(itemAsk)!,volume: Double(itemVolume)!,dataTime: itemDateTime,change: Double(itemChange)!,changePercent: Double(itemChangePercent)!)
           
            
            
            
            marketsItems.append(symbol)
        }
        if elementName == "Result" {
            displayItems = marketsItems
           
            DispatchQueue.main.async {
                for item in self.displayItems{
                    
                    let gt = Timer.scheduledTimer(timeInterval: TimeInterval(Int.random(in: 4...30)), target: self, selector: #selector(self.push), userInfo: item, repeats: true)
                    self.timerDict[item.id] = gt
                }
            }
            
            sortWrapperFunction()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @objc func push(timer:Timer){
        let obj:MarketsItem = timer.userInfo! as! MarketsItem
        
        var last = obj.last
        var tmp = Double.random(in:-20.0...20.0)
        var newValue = last + (last/100.0 * tmp)
        
        if newValue >= last{
            obj.color = 0
        }else if newValue < last{
            obj.color = 1
        }
        obj.change = last/100 * tmp
        obj.last = newValue
        obj.changePercent = tmp
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        for (id,dmc) in controllerDict{
            if id == obj.id{
                DispatchQueue.main.async {
                    dmc.tableView.reloadData()
                }
                
            }
        }
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.returnToNone), userInfo: obj, repeats: false)
    }
    @objc func returnToNone(timer:Timer){
        let obj:MarketsItem = timer.userInfo! as! MarketsItem
        obj.color = 2
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        for (id,dmc) in controllerDict{
            if id == obj.id{
                DispatchQueue.main.async {
                    dmc.tableView.reloadData()
                }
                
            }
        }
    }
    @objc func refreshTable(){
        DispatchQueue.main.async {
            for(_,timer) in self.timerDict{
                timer.invalidate()
            }
        }
        controllerDict.removeAll()
        timerDict.removeAll()
        marketsItems.removeAll()
        displayItems.removeAll()
        uploadMarketItems()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        refreshControl?.endRefreshing()
    }
    
    func uploadMarketItems(){
        let url = URL(string: urlMarkets)
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
    }
}
