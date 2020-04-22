//
//  CreateEntryViewController.swift
//  Journal
//
//  Created by Matthew Martindale on 4/21/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryLabel: UILabel!
    private var lineView: UIView = UIView()
    private let viewSize: CGSize = CGSize(width: 40, height: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    func setUp() {
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .gray

        view.addSubview(lineView)

        lineView.topAnchor.constraint(equalTo: entryLabel.bottomAnchor, constant: 12).isActive = true
        lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: viewSize.height).isActive = true
        lineView.widthAnchor.constraint(equalToConstant: viewSize.width).isActive = true
    }

}

