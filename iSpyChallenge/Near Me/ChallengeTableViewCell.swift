//
//  ChallengeTableViewCell.swift
//  iSpyChallenge
//

import UIKit
import CoreData

class ChallengeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var challenge: CDChallenge? {
        didSet {
            updateView()
        }
    }
    
    private let coreDataManager = CoreDataManager.shared
    
    private let cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let headerLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headerLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headerLabel3: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let footerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cardStackView)
        cardStackView.addArrangedSubview(headerStackView)
        cardStackView.addArrangedSubview(bodyLabel)
        cardStackView.addArrangedSubview(footerLabel)
        headerStackView.addArrangedSubview(headerLabel1)
        headerStackView.addArrangedSubview(headerLabel2)
        headerStackView.addArrangedSubview(headerLabel3)

        self.cardStackView.layer.cornerRadius = 12.0
        self.cardStackView.layer.masksToBounds = true
        contentView.backgroundColor = .systemGray5
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set up the layout for the main card stack view
        updateView()
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            cardStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            cardStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            cardStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            cardStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
        ])
        
        // Set up the layout for the header stack view
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: cardStackView.topAnchor, constant: 12.0),
            headerStackView.leftAnchor.constraint(equalTo: cardStackView.leftAnchor, constant: 12.0),
            headerStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -28.0)
        ])

        // Set up the layout for the body label
        NSLayoutConstraint.activate([
            bodyLabel.leftAnchor.constraint(equalTo: cardStackView.leftAnchor, constant: 12.0),
            bodyLabel.rightAnchor.constraint(equalTo: cardStackView.rightAnchor, constant: -12.0)
        ])

        // Set up the layout for the footer label
        NSLayoutConstraint.activate([
            footerLabel.leftAnchor.constraint(equalTo: cardStackView.leftAnchor, constant: 12.0),
            footerLabel.rightAnchor.constraint(equalTo: cardStackView.rightAnchor, constant: -12.0),
            footerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0)
        ])
    }
    
    // MARK: - Update View
    private func updateView() {
        guard let challenge = challenge else { return }
        
        let verifiedMatches = challenge.allMatches.filter({ $0.verified == true })
        headerLabel1.text = "\(verifiedMatches.count) wins"
        
        let ratings = challenge.allRatings
        let totalRatingValue = Double(ratings.reduce(0) { $0 + $1.stars }) / Double(ratings.count)
        headerLabel2.text =  String(format: "%0.2f stars", totalRatingValue.isNaN ? 0 : totalRatingValue)
        
        headerLabel3.text = String(format: "%0.2fm", challenge.distance)
        
        bodyLabel.text = challenge.hint
        footerLabel.text = "By: \(coreDataManager.getUsername(by: challenge.creatorID))"
        
        layoutIfNeeded()
    }
}
