//
//  RatesTableViewCell.swift
//  CurrencyApp
//
//  Created by Taha on 24.03.2021.
//

import UIKit

class RatesTableViewCell: UITableViewCell {

    var currencyName: UILabel!
    var currencyRate: UILabel!
    var currencyFlag: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        currencyName = UILabel()
        currencyName.font = .systemFont(ofSize: 13, weight: .semibold)
        currencyName.textColor = .black
        currencyName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(currencyName)
        
        currencyRate = UILabel()
        currencyRate.font = .systemFont(ofSize: 15, weight: .semibold)
        currencyRate.textColor = .black
        currencyRate.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(currencyRate)

        currencyFlag = UIImageView()
        currencyFlag.contentMode = .scaleAspectFit
        currencyFlag.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(currencyFlag)

        setupConstraints()
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            currencyFlag.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            currencyFlag.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),
            currencyFlag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            currencyFlag.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            currencyFlag.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -35)
            
        ])
        NSLayoutConstraint.activate([
            currencyName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            currencyName.leadingAnchor.constraint(equalTo: currencyFlag.trailingAnchor, constant: 15),
            currencyName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
        ])
        NSLayoutConstraint.activate([
            currencyRate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            currencyRate.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
         
            
        ])
    }
    
    func configure(currency: Currency){
        
        currencyRate.text = String(format:"%.2f", currency.rate)
        currencyName.text = currency.name.localized()
        currencyFlag.image = UIImage(named: currency.abbreviation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
