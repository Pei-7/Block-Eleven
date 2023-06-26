//
//  ViewController.swift
//  Block Eleven
//
//  Created by 陳佩琪 on 2023/6/12.
//

import UIKit

class ViewController: UIViewController {
    
    let themeBlue = UIColor(red: 33/255, green: 59/255, blue: 110/255, alpha: 1)
    let themeRed = UIColor(red: 229/255, green: 0/255, blue: 0/255, alpha: 1)
    
    
    let playView = UIView()
    let playingCardsView = UIView()
    
    var cards = [Card]()
    
    var cardsOnHand = [Card]()
    var cardsOnTable = [Card]()
    var cardsImages = [UIButton]()
    var cardsIndex = 0
    var selectedButton = [UIButton]()
    var selectedCards = [Card]()

    var cardsDeck = [UIButton]()
    
    var configuration = UIButton.Configuration.plain()
    
    let descriptionLabel = UILabel()
    
    let playAgainButton = UIButton(type: .system)
    let infoButton = UIButton(type: .system)
    
    let fireworkImageView = UIImageView()
    
    
    let instructionView = UIView()
    let instructionBackground = UIImageView()
    let sampleGif = UIImageView()
    let instructionLabel = UILabel()
    let nextButton = UIButton(type: .system)
    var pageNo = 0
    
    
    fileprivate func updateCardDeck() {
        //cards deck
        if cardsOnHand.count > 0 {
            for i in 1 ... cardsOnHand.count {
                //let playingCard = UIButton(frame: CGRect(x:33.5 , y: 70, width: 95, height: 126))
                
                let playingCard = UIButton(frame: CGRect(x:35.5 - 0.2 * Double((i-1)) , y: 61 - 0.15 * Double((i-1)), width: 95, height: 126))
                playingCard.layer.cornerRadius = 4
                playingCard.clipsToBounds = true
                playingCard.layer.borderWidth = 0.1
                playingCard.layer.borderColor = UIColor.white.cgColor
                
                //var configuration = UIButton.Configuration.plain()
                configuration.contentInsets = .init(top: -29.5, leading: -6.5, bottom: 0, trailing: 0)
                var title = AttributedString("🂠")
                title.font = UIFont.systemFont(ofSize: 155)
                title.foregroundColor = UIColor.white
                configuration.attributedTitle = title
                playingCard.configuration = configuration
                playingCard.backgroundColor = themeBlue
                playView.addSubview(playingCard)
                
                cardsDeck.append(playingCard)
                }
            } else {
                print("cardDeck=0")
                
                fireworkImageView.isHidden = false
                for card in cardsDeck {
                    card.removeFromSuperview()
                }
                
                var fireworkFrames = [UIImage]()
                for i in 0...45 {
                    fireworkFrames.append(UIImage(named: "frame_\(i)")!)
                }
                fireworkImageView.animationImages = fireworkFrames
                fireworkImageView.startAnimating()
                
                descriptionLabel.text = "Claim yourself a winner!"

            }
        }
    
    fileprivate func setCards(_ cards: [Card]) {
        cardsOnHand = cards.shuffled()
        
        for i in 0...3 {
            for j in 0...2 {
                let playingCard = UIButton(type: .system)
                
                playingCard.frame = CGRect(x: 0 + 115 * j, y: 0 + 149 * i, width: 95, height: 129)
                playingCard.layer.cornerRadius = 4
                playingCard.clipsToBounds = true
                playingCard.backgroundColor = UIColor.white
                cardsImages.append(playingCard)
                
                var currentCard = cardsOnHand[cardsIndex]
                while currentCard.rank > 10 {
                    cardsOnHand.append(currentCard)
                    cardsOnHand.remove(at: cardsIndex)
                    currentCard = cardsOnHand[cardsIndex]
                }
                
                let cardImage = currentCard.image
                cardsOnTable.append(cardsOnHand[cardsIndex])
                print(cardsOnHand[cardsIndex].rank, cardsOnHand[cardsIndex].suit)
                cardsOnHand.remove(at: cardsIndex)
                cardsIndex += 1
                
                //var configuration = UIButton.Configuration.plain()
                configuration.contentInsets = .init(top: -30.5, leading: -10.5, bottom: 0, trailing: 0)
                var title = AttributedString(cardImage)
                if currentCard.suit == Suit.spade ||  currentCard.suit == Suit.club {
                    title.foregroundColor = UIColor.black
                } else {
                    title.foregroundColor = themeRed
                }
                title.font = UIFont.systemFont(ofSize: 166)
                configuration.attributedTitle = title
                playingCard.configuration = configuration
                playingCardsView.addSubview(playingCard)
                
                
                playingCard.addAction(UIAction(handler: {[self, weak playingCard] _ in
                    print("clicked")
                    playingCard?.backgroundColor = UIColor.systemGray3
                    
                    let index = cardsOnTable.firstIndex(where: {$0.image == playingCard!.titleLabel?.text})
                    //print("index",index)
                    let currentCard = cardsOnTable[index!]
                    selectedButton.append(playingCard!)
                    selectedCards.append(currentCard)
                    print("button:",selectedButton.count, "cards:",selectedCards.count,currentCard.suit, currentCard.rank)
                    checkEleven()
                }), for: .touchUpInside)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //cards
        let suits = [Suit.spade, Suit.heart, Suit.diamond, Suit.club]
        let ranks = Array(1...13)
        let images = ["🂡","🂢","🂣","🂤","🂥","🂦","🂧","🂨","🂩","🂪","🂫","🂭","🂮","🂱","🂲","🂳","🂴","🂵","🂶","🂷","🂸","🂹","🂺","🂻","🂽","🂾","🃁","🃂","🃃","🃄","🃅","🃆","🃇","🃈","🃉","🃊","🃋","🃍","🃎","🃑","🃒","🃓","🃔","🃕","🃖","🃗","🃘","🃙","🃚","🃛","🃝","🃞"]

        var index = 0
        for suit in suits {
            for rank in ranks {
                let card = Card(suit: suit, rank: rank, image: images[index])
                index += 1
                cards.append(card)
            }
        }

        
        playView.frame = view.frame
        view.addSubview(playView)
        
        let background = UIImageView()
        background.frame = playView.frame
        background.image = UIImage(named: "background")
        playView.addSubview(background)
        
        playingCardsView.frame = CGRect(x: 33.5, y: 220, width: 357, height: 676)
        playView.addSubview(playingCardsView)
                
        setCards(cards)
        
        fireworkImageView.frame = CGRect(x: 30, y: 80, width: 95, height: 92)
        playView.addSubview(fireworkImageView)
        fireworkImageView.isHidden = true
        
        updateCardDeck()
        
        descriptionLabel.frame = CGRect(x: 141, y: 118, width: 220, height: 60)
        descriptionLabel.text = "Pair two cards to\n make 11."
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        descriptionLabel.layer.cornerRadius = 24
        descriptionLabel.clipsToBounds = true
        playView.addSubview(descriptionLabel)
        
        
        playAgainButton.frame = CGRect(x: 276, y: 68, width: 80, height: 44)
        playAgainButton.setTitle("Restart", for: .normal)
        playAgainButton.titleLabel?.textAlignment = .right
        playAgainButton.setImage(UIImage(systemName: "arrow.uturn.right.circle"), for: .normal)
        playAgainButton.tintColor = UIColor.white
        playView.addSubview(playAgainButton)
        playAgainButton.addAction(UIAction(handler: {[self] _ in
            replay()
        }), for: .touchUpInside)
        
        
        instructionView.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        instructionView.isHidden = true
        playView.addSubview(instructionView)
        
        instructionBackground.frame = instructionView.frame
        instructionBackground.image = UIImage(named: "background")
        instructionView.addSubview(instructionBackground)
        
        
        instructionLabel.frame = CGRect(x: 30, y: 690, width: 330, height: 120)
        instructionView.addSubview(instructionLabel)
        
        instructionLabel.lineBreakMode = .byWordWrapping
        instructionLabel.numberOfLines = 0
        instructionLabel.textAlignment = .center
        instructionLabel.text = "1. Click on 2 cards that add up to 11. Two new cards from the deck will be placed on top of them.\n\nnext >"
        instructionLabel.textColor = UIColor.white
        instructionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        
        sampleGif.frame = CGRect(x: 41, y: 56, width: 308, height: 612)
        var step1Gif = [UIImage]()
        for i in 0 ... 41 {
            step1Gif.append(UIImage(named: "step1_\(i)")!)
        }
        var step2Gif = [UIImage]()
        for i in 0 ... 44 {
            step2Gif.append(UIImage(named: "step2_\(i)")!)
        }
        var step3Gif = [UIImage]()
        for i in 0 ... 106 {
            step3Gif.append(UIImage(named: "step3_\(i)")!)
        }
        sampleGif.animationImages = step1Gif
        sampleGif.startAnimating()
        instructionView.addSubview(sampleGif)
        
        infoButton.frame =  CGRect(x: 141, y: 68, width: 110, height: 44)
        infoButton.setTitle("How to play", for: .normal)
        infoButton.titleLabel?.textAlignment = .right
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.tintColor = UIColor.white
        playView.addSubview(infoButton)
        infoButton.addAction(UIAction(handler: {[self] _ in
            pageNo = 1
            instructionView.isHidden = false
            infoButton.isHidden = true
            for card in cardsDeck {
                card.isHidden = true
            }
            instructionLabel.text = "1. Click on 2 cards that add up to 11. Two new cards from the deck will be placed on top of them.\n\nnext >"
            sampleGif.animationImages = step1Gif
            sampleGif.startAnimating()
        }), for: .touchUpInside)

        
        nextButton.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        instructionView.addSubview(nextButton)
        nextButton.setTitle("", for: .normal)
        nextButton.addAction(UIAction(handler: { [self] _ in
            pageNo += 1
            print(pageNo)
            if pageNo == 2 {
                instructionLabel.text = "2. If a pile has a J, Q, or K on top, it is considered blocked.\n\nnext >"
                sampleGif.animationImages = step2Gif
                sampleGif.startAnimating()
            } else if pageNo == 3 {
                instructionLabel.text = "3. Continue playing until all piles are blocked (win🥳!), or you run out of moves (failed😕).\n\nnext >"
                sampleGif.animationImages = step3Gif
                sampleGif.startAnimating()
            } else {
                instructionView.isHidden = true
                for card in cardsDeck {
                    card.isHidden = false
                }
                infoButton.isHidden = false
            }
        }), for: .touchUpInside)

    }

    
    
    func checkEleven() {
        if selectedButton.count == 2 {
            
            if selectedCards[0].rank + selectedCards[1].rank == 11 {
                
                
                var index = 0
                for button in selectedButton {
                    //button.setTitle(cardsOnHand[index].image, for: .normal)
                    var title = AttributedString(cardsOnHand[index].image)
                    if cardsOnHand[index].suit == .spade ||  cardsOnHand[index].suit == .club {
                        title.foregroundColor = UIColor.black
                    } else {
                        title.foregroundColor = themeRed
                    }
                    title.font = UIFont.systemFont(ofSize: 166)
                    configuration.contentInsets = .init(top: -30.5, leading: -10.5, bottom: 0, trailing: 0)
                    configuration.attributedTitle = title
                    button.configuration = configuration
                    
                    if cardsOnHand[index].rank > 10 {
                        button.isEnabled = false
                    }
                    
                    cardsOnTable.append(cardsOnHand[index])
                    cardsOnHand.remove(at: index)
                    
                    if cardsOnHand.count == 0 {
                        cardsIndex = 0
                    }
                    
                    let cardImage = UIImageView(image: UIImage(named: "singleCard"))
                    playView.addSubview(cardImage)
                    cardImage.frame = CGRect(x: 35, y: 60, width: 95, height: 126)
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [self] in
                        cardImage.transform = CGAffineTransform(translationX: button.center.x + playingCardsView.frame.minX - cardImage.center.x , y: button.center.y + playingCardsView.frame.minY - cardImage.center.y)
                    }, completion: nil)
                    UIView.animate(withDuration: 0.02, delay: 0.18, options: .curveEaseInOut, animations: {
                        cardImage.alpha = 0
                    }, completion: nil)
                    
                    if cardsOnHand.count > 1 {
                        index += 1
                    } else {
                        index = 0
                    }
                }

                print("cards left:",cardsOnHand.count)
                
                for card in cardsDeck {
                    card.removeFromSuperview()
                }
                cardsDeck.removeAll()
                print(cardsOnHand.count)
                updateCardDeck()
                
                
            } else {
                for button in selectedButton {
                    print("animation")
                    UIView.animate(withDuration: 0.06, delay: 0, options: [.autoreverse, .repeat], animations: {
                        button.transform = CGAffineTransform(translationX: -8, y: 0)
                    }, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        button.layer.removeAllAnimations()
                    }
                    button.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            }
            
            
            for button in selectedButton {
                button.backgroundColor = UIColor.white
            }
            selectedButton.removeAll()
            selectedCards.removeAll()
            
        }
    }
    

    func replay() {
        print("clicked replay butotn")
        cardsIndex = 0
        selectedCards.removeAll()
        cardsOnHand.removeAll()
        cardsOnTable.removeAll()
        for card in cardsImages {
            card.removeFromSuperview()
        }
        for card in cardsDeck {
            card.removeFromSuperview()
        }
        setCards(cards)
        updateCardDeck()
        descriptionLabel.text = "Pair two cards to\n make 11."
    }

}

