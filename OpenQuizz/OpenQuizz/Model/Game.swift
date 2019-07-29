//
//  Game.swift
//  OpenQuizz
//
//  Created by Ambroise COLLON on 13/06/2017.
//  Copyright Â© 2017 OpenClassrooms. All rights reserved.
//

import Foundation


class Game {
    var score = 0
    
    private var questions = [Question]()
    private var currentIndex = 0
    
    enum State {
        case ongoing, over
    }
    
    var state: State = .ongoing
    
    var currentQuestion: Question {
        print("index de la question: Titre: \(questions[currentIndex].title)")
        return questions[currentIndex]
    }
    
    func refresh() {
        print("1/ Etat: \(self.state) / Titre \(self.questions)")
        score = 0
        currentIndex = 0
        state = .ongoing
        
        QuestionManager.shared.get{ (questions/*:[Question]*/) ->() in // comme "CompletionHandeler prend en parametre une fonction qui a comme vableur tableau de question il va deduire tout seul que "questions" est un tableau de question. 2min 30
            self.questions = questions
            self.state = .ongoing
            
            let name = Notification.Name("QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            print("1/ Etat: \(self.state) / Titre \(self.questions)")
            
        }
        // shared: instance unique de question manager.
        // On passe en parametre la fonction que l'on vient de créer
        // L'orsque les questions sont chargé c'est la méthode receive question qui va etre appelé avec en paramaetre les questions recus
        // On peut testé avec app delegate avec la méthode fapplication qui se lance à chaque démarrage.
    }
    
    private func receiveQuestions(_ questions:[Question]){ // Valeur tableau de question
        self.questions = questions // On assigne les questions que l'on vient de recevoir à la propriété question de notre class "Game"
        print(questions) // affichage des qestions chargés
        print("récupération des question")
        state = .ongoing // on modifie l'état de la partie, pour dire qu'elle est prete à démarrer
    }
    
    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
            print("Ajout d'un point")
        }
        goToNextQuestion()
    }
    
    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            print("question suivante")
            
        } else {
            finishGame()
        }
    }
    
    private func finishGame() {
        state = .over
    }
}
