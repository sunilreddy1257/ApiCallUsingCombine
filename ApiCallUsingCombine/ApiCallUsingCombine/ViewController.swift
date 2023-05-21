//
//  ViewController.swift
//  ApiCallUsingCombine
//
//  Created by Sunil Kumar Reddy Sanepalli on 21/05/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var labelText: UILabel!
    
    private var cancellabels = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.labelText.text = "Hello"
        self.getApiCall()
    }
    
    func getApiCall() {
        NetworkManager.shared.apiCallUsingCombine(type: Todos.self)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                default:
                    print("completion error")
                }
            } receiveValue: { todosData in
                print(todosData.title)
                self.labelText.text = "\(todosData.title)"
            }
            .store(in: &self.cancellabels)
    }

}

