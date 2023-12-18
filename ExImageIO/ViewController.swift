//
//  ViewController.swift
//  ExImageIO
//
//  Created by 김종권 on 2023/12/10.
//

import UIKit

class ViewController: UIViewController {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let img = UIImage(named: "big_img")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        imageView.image = img
    }
    
    func bind() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            print("foreground")
            self?.imageView.image = self?.img
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            print("background")
            self?.imageView.image = nil
        }
    }
}
