//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Taha on 24.03.2021.
//

import UIKit


class ViewController: UIViewController {
    
  //  var tableView: UITableView!
    var basePickerView: UIPickerView!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var baseTextField: UITextField!
    
    let reuseIdentifier = "RatesTableViewCellReuse"
    let toDetailVcSegueIdentifier = "toDetailVC"
    
    var currencies = [Currency]()
    var choosenCurrencyForDetail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Currencies".localized()
        
        basePickerView = UIPickerView()
        basePickerView.translatesAutoresizingMaskIntoConstraints = false
        basePickerView.backgroundColor = .white
        basePickerView.isOpaque = true
        basePickerView.alpha = 0.97
        basePickerView.dataSource = self
        basePickerView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RatesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = .init(view.frame.height * 0.12)
       
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
        
        let locale = Locale.current
        getRates(for: locale.currencyCode ?? "TRY")
    }

    @objc func donePressed(sender: UIBarButtonItem) {
        let row = basePickerView.selectedRow(inComponent: 0)
        baseTextField.text = "\(currencies[row].abbreviation)".localized()
        baseTextField.resignFirstResponder()
        getRates(for: currencies[row].abbreviation)
    }
    
    @objc func cancelPressed(sender: UIBarButtonItem) {
        baseTextField.resignFirstResponder()
     }
    
    func getRates(for base: String) {
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
        if segue.identifier == toDetailVcSegueIdentifier {
            let destination = segue.destination as! DetailViewController
            destination.configure(base: choosenCurrencyForDetail)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenCurrencyForDetail = self.currencies[indexPath.row].abbreviation
        performSegue(withIdentifier: toDetailVcSegueIdentifier, sender: nil)
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

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
