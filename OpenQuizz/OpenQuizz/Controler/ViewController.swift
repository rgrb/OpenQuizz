//
//  ViewController.swift
//  OpenQuizz
//
//  Created by rgrb on 10/01/2019.
//  Copyright © 2019 rgrb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var questionView: QuestionView!
    
    var game = Game() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(
            self, selector: #selector(questionsLoaded),
            name: name, object: nil)
        startNewGame() // On lance une partie tout de suite
        print("3/ Question: \(questionView.title) ( viewDidLoad() )")
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector (dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    
    @objc func dragQuestionView (_ sender: UIPanGestureRecognizer ){
        if game.state == .ongoing {
            switch sender.state{
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
  
        let screenWidth = UIScreen.main.bounds.width // largeur de l'ecran
        let translationPercent = translation.x/(screenWidth/2) // Ou j'en suis par rapport au bord de l'ecran.
        let rotationAngle =  (CGFloat.pi / 6) * translationPercent // Pour trouver l'angle /6
        
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        let transform = translationTransform.concatenating(rotationTransform) // On combine les deux
        questionView.transform = transform
        
        if translation.x > 5 {
            questionView.style = .correct
        }else if translation.x < -5 {
            questionView.style = .incorrect
        }else{
            questionView.style = .standart
        }
        
    }
    
    private func answerQuestion(){
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standart:
            break
        }
        
        scoreLabel.text = "\(game.score) / 10"
        

        
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform // variable vide contient notre transofrmation
        if questionView.style == .correct { // si la ttranslation est correct (mouvement vers la droite), donc la translation va vers la droite
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else { // si elle n'est pas correct on l'a fait vers la gauche
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }) { (success) in // on verifie si l'animation c'est déroulé correctement
            if success  {
                self.showQuestionView()
            }
        }
        
    }
    private func showQuestionView(){
        questionView.transform = .identity// on ramene la vue au centre de l'ecrant
        questionView.style = .standart
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity // Ramene la vue à sa taille d'origine
        }, completion: nil)
    }
    
    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        questionView.title = game.currentQuestion.title
        print("4/ Question actuelle \(game.currentQuestion.title)")
    
    }

    @IBAction func didTapNewGameButton() {
        
        startNewGame()
        print("5/ Rafraichissement de la partie")
    }// bonne pratique de séparer l'action de la logique
    
    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        
        questionView.title = "Loading..."
        questionView.style = .standart
        
        scoreLabel.text = "0 / 10"
        game.refresh()
    }// Affiche une interface de chargement, lance le chargement des questions, lorque les questions sont chargées, la partie peut débuter.
}

