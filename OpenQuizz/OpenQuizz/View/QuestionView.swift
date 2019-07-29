//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by rgrb on 12/01/2019.
//  Copyright © 2019 rgrb. All rights reserved.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet private var label: UILabel! // le rond nous permet de faire la connexion
    @IBOutlet private var icon: UIImageView! // one connais pas les valeurs

    enum Style {
        case correct, incorrect, standart
    }
    
    var style:Style = .standart {
        didSet {
            setStyle(style)
        }
    }
    // à travailler
    private func setStyle(_ style: Style) {
        switch style {
        case .correct:
            backgroundColor = #colorLiteral(red: 0.7855075598, green: 0.9265916348, blue: 0.6280687451, alpha: 1)
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9511083961, green: 0.5300352573, blue: 0.5810187459, alpha: 1)
            icon.image = UIImage(named: "Icon Error")
            icon.isHidden = false
        case .standart:
            backgroundColor = #colorLiteral(red: 0.8492125869, green: 0.7961511612, blue: 0.6208475232, alpha: 1)
            icon.isHidden = true
            
        }
            
    }
    
    var title = "" {
        didSet {
            // Dès que la propriété de la valeur title va etre modifié didset va etre executé.
            label.text = title
        }
    }
}
