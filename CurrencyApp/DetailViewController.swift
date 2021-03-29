//
//  DetailViewController.swift
//  CurrencyApp
//
//  Created by Taha on 26.03.2021.
//

import UIKit
import Charts

class DetailViewController: UIViewController {
    
    var tableView: UITableView!
    let reuseIdentifier = "DetailRatesTableViewCellReuse"
    var currencies = [Currency]()
    lazy var lineChartView = LineChartView()
    var chartValues = [ChartDataEntry]()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        lineChartView.rightAxis.enabled = false
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.backgroundColor = .systemBlue
        view.addSubview(lineChartView)
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RatesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = .init(view.frame.height * 0.1)
        view.addSubview(tableView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineChartView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
            
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: lineChartView.bottomAnchor,constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
     
     
    }
    
    func getRates(base: String){
        RatesApiService.getRates(base: base) { (rates) in
            self.currencies.removeAll()
            
            for (key, value) in rates.rates {
                let currenyName = Constants.currencyMap[key]
                let currency = Currency(name: currenyName ?? " ", rate: value, abbreviation: key)
                self.currencies.append(currency)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
           
        }
    }
    func fillGraph(base: String, to: String) {
        chartValues.removeAll()
        let datesBetweenArray = Date.dates(from: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, to: Date())
        for date in datesBetweenArray {
            print(date.description.split(separator: " ").first!)
        }
        
        RatesApiService.getRatesBetweenDates(from: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, to: Date(), base: base, toConvert: to) { (curreny) in
           
            let entry = ChartDataEntry(x: Double(self.chartValues.count), y: Double(curreny.rate))
                self.chartValues.append(entry)
                let set1 = LineChartDataSet(entries: self.chartValues, label: "\(base) -> \(to)")
                set1.drawCirclesEnabled = false
                set1.lineWidth = 3
                set1.setColor(.white)
                set1.mode = .cubicBezier
                
                let data = LineChartData(dataSet: set1)
                self.lineChartView.data = data
            
            
        }
    }

    func configure(base: String) {
        
        self.title = base
        getRates(base: base)
        fillGraph(base: base, to: currencies.first?.abbreviation ?? "TRY" )

    }
    

}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RatesTableViewCell
        //print(currencies[indexPath.row])
        cell.configure(currency: currencies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fillGraph(base: self.title!, to: currencies[indexPath.row].abbreviation)
    }
    
}
extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
