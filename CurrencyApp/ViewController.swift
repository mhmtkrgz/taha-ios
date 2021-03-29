//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Taha on 24.03.2021.
//

import UIKit


class ViewController: UIViewController {
    
    var tableView: UITableView!
    var basePickerView: UIPickerView!

    
    @IBOutlet weak var baseTextField: UITextField!
    
    let reuseIdentifier = "RatesTableViewCellReuse"
    var currencies = [Currency]()
    var detailBase: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Currency App"
        
        currencies.append(Currency(name: "Turkish Liras", rate: 1.0, abbreviation: "TRY"))
        
        basePickerView = UIPickerView()
        basePickerView.translatesAutoresizingMaskIntoConstraints = false
        basePickerView.backgroundColor = .white
        basePickerView.isOpaque = true
        basePickerView.alpha = 0.97
        basePickerView.dataSource = self
        basePickerView.delegate = self
 
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RatesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = .init(view.frame.height * 0.12)
        view.addSubview(tableView)
        //view.addSubview(basePickerView)
    

        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        toolbar.barStyle = .default
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.donePressed(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ViewController.cancelPressed(sender:)))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        
        toolbar.sizeToFit()
        toolbar.isUserInteractionEnabled = true
        baseTextField.inputView = basePickerView
        baseTextField.inputAccessoryView = toolbar
        
        
        
        getRates(base: "TRY")
        setupConstraints()
        
        

    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        let row = basePickerView.selectedRow(inComponent: 0)
        print(currencies[row].abbreviation)
        baseTextField.text = "\(currencies[row].abbreviation)".localized()
        baseTextField.resignFirstResponder()
        getRates(base: currencies[row].abbreviation)
    }
    @objc func cancelPressed(sender: UIBarButtonItem) {
      
        baseTextField.resignFirstResponder()
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: baseTextField.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        /*NSLayoutConstraint.activate([
            //basePickerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            basePickerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            basePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            basePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            basePickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])*/
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
                self.basePickerView.reloadAllComponents()
            }
           
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destination = segue.destination as! DetailViewController
            destination.configure(base: detailBase)
        }
    }
    
  

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailBase = self.currencies[indexPath.row].abbreviation
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RatesTableViewCell
        print(currencies[indexPath.row])
        cell.configure(currency: currencies[indexPath.row])
        return cell
    }
}

extension ViewController: UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].abbreviation
    }
    
}

extension ViewController: UIPickerViewDelegate {
   
}

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
