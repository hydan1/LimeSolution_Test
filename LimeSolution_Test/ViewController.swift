//
//  ViewController.swift
//  LimeSolution_Test
//
//  Created by Hydan on 4/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var buttonStackView: UIStackView!
    private var logo: UIButton!
    
    private var cards: [UIView] = [] // Array to hold card views
    private var swipedCards: [SwipedCard] = [] // Array to store removed cards
    private let users: [User] = [
        User(name: "Lan", age: 28, location: "Ho Chi Minh", distance: 5.4, imageUrl: "https://qph.cf2.quoracdn.net/main-qimg-57077525030f9b877265ae24634ad2f2-lq"),
        User(name: "Chi", age: 26, location: "Ho Chi Minh", distance: 9.8, imageUrl: "https://i.pinimg.com/736x/6a/7c/d7/6a7cd714e121a8c9bcded00fd91483ba.jpg"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogo()
        setupCards()
        setupButtons()
    }
    
    private func setupLogo() {
        logo = UIButton()
        logo.setImage(UIImage(systemName: "flame.fill"), for: .normal)
        logo.setTitle("Lime Solution", for: .normal)
        logo.setTitleColor(.systemPink, for: .normal)
        logo.tintColor = .systemPink
        view.addSubview(logo)
        
        if var config = logo.configuration {
            config.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 0)
        }
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            logo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
        ])
    }
    
    private func setupCards() {
        for i in 0..<20 {
            let card = createCardView(for: users[i%2]) // Create card for the first user
            cards.append(card) // Add card to the array
            view.addSubview(card) // Add card to the view
            
            card.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                card.widthAnchor.constraint(equalTo: view.widthAnchor),
                card.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
                card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                card.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
    
    private func createCardView(for user: User) -> UIView {
        // Create the card with rounded corners and shadow
        let cardView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 4/5))
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        // Background image view
        let imageView = UIImageView(frame: cardView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cardView.addSubview(imageView)
        
        // Load image asynchronously from URL
        if let imageUrl = URL(string: user.imageUrl) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, error == nil, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image // Set image to the imageView
                    }
                }
            }.resume()
        }
        
        // Name label
        let nameLabel = UILabel()
        nameLabel.text = "\(user.name), \(user.age)"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(nameLabel)
        
        // Location label
        let locationLabel = UILabel()
        locationLabel.text = user.location
        locationLabel.textColor = .white
        locationLabel.font = UIFont.systemFont(ofSize: 18)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(locationLabel)
        
        // Distance label
        let distanceLabel = UILabel()
        distanceLabel.text = "\(user.distance) km away"
        distanceLabel.textColor = .white
        distanceLabel.font = UIFont.systemFont(ofSize: 16)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(distanceLabel)
        
        // Gradient overlay to darken the bottom part of the card
        let gradientOverlay = UIView()
        gradientOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cardView.insertSubview(gradientOverlay, belowSubview: nameLabel)
        gradientOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientOverlay.widthAnchor.constraint(equalTo: cardView.widthAnchor),
            gradientOverlay.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            gradientOverlay.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            gradientOverlay.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -12)
        ])
        
        // Add Auto Layout constraints for labels
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            distanceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            distanceLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            distanceLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -40)
        ])
        
        // Add gesture recognizer for swiping
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(_:)))
        cardView.addGestureRecognizer(panGesture)
        
        return cardView // Return the created card view
    }
    
    private func setupButtons() {
        // Button icons (replace with your icon images)
        let buttonIcons = ["back", "close", "star", "heart", "paper-plane"]
        
        // Create button stack view (above the card)
        buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalSpacing
        buttonStackView.alignment = .center
        buttonStackView.spacing = 10
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        
        
        // Set Auto Layout for stack view
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60) // Height of stack view
        ])
        
        for (index, iconName) in buttonIcons.enumerated() {
            let button = UIButton(type: .system)
            
            // Load the image and set rendering mode
            let image = UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal)
            button.setImage(image, for: .normal) // Set icon image
            
            // Set button properties
            button.tintColor = .white // Set icon color
            button.backgroundColor = .white // Set button background color
            let cornerRadius: CGFloat = index % 2 == 0 ? 25 : 30
            button.layer.cornerRadius = cornerRadius // Make button circular
            button.clipsToBounds = false // Allow shadows to be visible
            
            // Add shadow to the button
            button.layer.shadowColor = UIColor.black.cgColor // Shadow color
            button.layer.shadowOpacity = 0.3 // Shadow opacity
            button.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset
            button.layer.shadowRadius = 5 // Shadow radius
            
            // Adjust button size
            let size: CGFloat = index % 2 == 0 ? 50 : 60
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: size),
                button.heightAnchor.constraint(equalToConstant: size)
            ])
            
            // Adjust icon size
            button.imageView?.contentMode = .scaleAspectFit // Ensures the image fits within the button
            button.setImage(image, for: .normal) // Set icon image again after content mode adjustment
            let padding: CGFloat = index % 2 == 0 ? 12 : 15
            button.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding) // Adjust image insets to make it smaller
            
            
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) // Add action for button tap
            button.tag = buttonIcons.firstIndex(of: iconName) ?? 0 // Assign tag to identify the button
            buttonStackView.addArrangedSubview(button) // Add button to stack view
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("Back") // Handle "Back" action
            // Perform action for "Back"
            onBackAction()
        case 1:
            print("Nope") // Handle "Nope" action
            // Perform swipe left action
            if let topCard = cards.last {
                onSwipeAction(topCard, to: .left) // Swipe left
            }
        case 2:
            print("Super Like") // Handle "Super Like" action
            // Perform swipe up action
            if let topCard = cards.last {
                onSwipeAction(topCard, to: .up) // Swipe up
            }
        case 3:
            print("Like") // Handle "Like" action
            // Perform swipe right action
            if let topCard = cards.last {
                onSwipeAction(topCard, to: .right) // Swipe right
            }
        case 4:
            print("Send message") // Handle "Send Message" action
            // Perform action for "Send Message"
        default:
            break
        }
    }
    
    @objc private func handleCardPan(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view else { return }
        
        let translation = gesture.translation(in: view) // Get translation of the gesture
        let centerOffset = view.center.x - card.center.x // Calculate offset from center
        
        // Update card position based on drag
        card.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        
        // Rotate card based on drag distance
        let rotationStrength = min(centerOffset / view.center.x, 1) // Limit rotation strength
        let rotationAngle = (CGFloat.pi / 8) * rotationStrength // Calculate rotation angle
        card.transform = CGAffineTransform(rotationAngle: rotationAngle) // Apply rotation
        
        if gesture.state == .ended { // When gesture ends
            let cardEndX = card.center.x
            let cardEndY = card.center.y
            
            // Swipe Right
            if cardEndX > view.frame.width * 0.75 {
                onSwipeAction(card, to: .right) // Swipe right
                print("Swiped right")
            }
            // Swipe Left
            else if cardEndX < view.frame.width * 0.25 {
                onSwipeAction(card, to: .left) // Swipe left
                print("Swiped left")
            }
            // Swipe Up
            else if cardEndY < view.frame.height * 0.25 {
                onSwipeAction(card, to: .up) // Swipe up
                print("Swiped up")
            }
            // Return to center if not swiped enough
            else {
                UIView.animate(withDuration: 0.3) {
                    card.center = self.view.center // Return card to center
                    card.transform = .identity // Reset rotation
                }
            }
        }
    }
    
    private func onSwipeAction(_ card: UIView, to direction: SwipeDirection) {
        var endPoint = card.center // Store original center position
        var rotationAngle: CGFloat = 0.0 // Initialize rotation angle
        var directionOfCard: SwipeDirection = .right
        switch direction {
        case .right:
            endPoint = CGPoint(x: view.frame.width + card.frame.width, y: card.center.y) // End point for right swipe
            rotationAngle = .pi / 8 // Rotate card
        case .left:
            endPoint = CGPoint(x: -card.frame.width, y: card.center.y) // End point for left swipe
            rotationAngle = -.pi / 8 // Rotate card
            directionOfCard = .left
        case .up:
            endPoint = CGPoint(x: card.center.x, y: -card.frame.height) // End point for up swipe
            directionOfCard = .up
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            card.center = endPoint // Animate to end point
            card.transform = CGAffineTransform(rotationAngle: rotationAngle) // Animate rotation
        }) { [self] _ in
            if !self.cards.isEmpty {
                self.cards.removeLast() // Remove card from array
            }
            buttonStackView.isHidden = cards.isEmpty
            card.transform = .identity
            addSwipedCard(card, direction: directionOfCard)
        }
    }
    
    private func onBackAction() {
        guard let lastSwipedCard = swipedCards.popLast() else {
            return // No card swiped
        }

        let card = lastSwipedCard.card
        view.insertSubview(card, belowSubview: buttonStackView)
        cards.append(card)
        
        var startPoint = card.center
        var reverseRotationAngle: CGFloat = 0.0

        switch lastSwipedCard.direction {
        case .right:
            startPoint = CGPoint(x: view.frame.width + card.frame.width, y: card.center.y) // From right to center
            reverseRotationAngle = -.pi / 8
        case .left:
            startPoint = CGPoint(x: -card.frame.width, y: card.center.y) // From left to center
            reverseRotationAngle = .pi / 8
        case .up:
            startPoint = CGPoint(x: card.center.x, y: -card.frame.height) // From top to bottom
        }
        
        card.center = startPoint
        card.transform = CGAffineTransform(rotationAngle: reverseRotationAngle)

        UIView.animate(withDuration: 0.5, animations: {
            card.center = self.view.center
            card.transform = .identity // Reset rotation to 0
        })
    }

                               
    private func addSwipedCard(_ card: UIView, direction: SwipeDirection) {
        let swipedCard = SwipedCard(card: card, direction: direction)
        swipedCards.append(swipedCard)
    }
    
    enum SwipeDirection {
        case left // Swipe left
        case right // Swipe right
        case up // Swipe up
    }
    
    struct SwipedCard {
        let card: UIView
        let direction: SwipeDirection
    }
}
