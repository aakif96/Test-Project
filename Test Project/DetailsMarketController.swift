//
//  DetailsMarketController.swift
//  Test Project
//
//  Created by Alen Akif on 21.11.22..
//

import Foundation
import UIKit




class DetailsMarketController: UITableViewController {
    
    var marketItem: MarketsItem
    var mvc: MarketViewController
    var dataLabels = ["ID:","Name:","Ticker Symbol:","isin:","Currency:","Stock Exchange Name:","Decorative Name:","Last:","High:","Low:","Bid:","Ask:","Volume:","Data Time:","Change:","Change Percent:"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //marketItem.updateData()
        tableView.allowsSelection = false
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        16
    }
    override func viewWillDisappear(_ animated: Bool) {
        mvc.controllerDict.removeValue(forKey: marketItem.id)
    }
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsMarketCell", for: indexPath) as! DetailsMarketCell
        cell.dataLabel.text = dataLabels[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.dataValueLabel.text = marketItem.id
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 1:
            cell.dataValueLabel.text = marketItem.name
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 2:
            cell.dataValueLabel.text = marketItem.ticketSymbol
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 3:
            cell.dataValueLabel.text = marketItem.isin
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 4:
            cell.dataValueLabel.text = marketItem.currency
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 5:
            cell.dataValueLabel.text = marketItem.stockExchangeName
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 6:
            cell.dataValueLabel.text = marketItem.decorativeName
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 7:
            cell.dataValueLabel.text = formatString(word:String(marketItem.last))
            cell.dataValueLabel.textColor = .label
            if marketItem.color == 0{
                cell.dataValueLabel.backgroundColor = .green
            }else if marketItem.color == 1{
                cell.dataValueLabel.backgroundColor = .red
            }else if marketItem.color == 2{
                cell.dataValueLabel.backgroundColor = .none
            }
        case 8:
            cell.dataValueLabel.text = String(marketItem.high)
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 9:
            cell.dataValueLabel.text = String(marketItem.low)
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 10:
            cell.dataValueLabel.text = String(marketItem.bid)
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 11:
            cell.dataValueLabel.text = String(marketItem.ask)
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 12:
            cell.dataValueLabel.text = String(marketItem.volume)
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 13:
            cell.dataValueLabel.text = marketItem.dataTime
            cell.dataValueLabel.textColor = .label
            cell.dataValueLabel.backgroundColor = .none
        case 14:
            cell.dataValueLabel.text = formatString(word:String(marketItem.change))
            if marketItem.change > 0 {
                cell.dataValueLabel.textColor = .green
            }
            if marketItem.change < 0{
                cell.dataValueLabel.textColor = .red
            }
            if marketItem.change == 0{
                cell.dataValueLabel.textColor = .label
            }
            cell.dataValueLabel.backgroundColor = .none
        case 15:
            cell.dataValueLabel.text = formatString(word:String(marketItem.changePercent)) + "%"
            if marketItem.changePercent > 0 {
                cell.dataValueLabel.textColor = .green
            }
            if marketItem.changePercent < 0{
                cell.dataValueLabel.textColor = .red
            }
            if marketItem.changePercent == 0{
                cell.dataValueLabel.textColor = .label
            }
            cell.dataValueLabel.backgroundColor = .none
        default:
            cell.dataValueLabel.text = "Error"
        }
        return cell
        
    }
    required init?(coder: NSCoder) {
        fatalError("Fatal Error")
    }
    init?(coder: NSCoder, marketItem:MarketsItem,mvc: MarketViewController) {
        self.mvc = mvc
        self.marketItem = marketItem
        super.init(coder: coder)
    }
    
    
    
}
