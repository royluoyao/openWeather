//
//  DetailViewController.swift
//  openWeather
//
//  Created by user on 2021/12/24.
//

import UIKit

class DetailViewController: UIViewController {
    var model : Daily?
    private lazy var detailLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.blue
        view.font = UIFont.systemFont(ofSize: 24)
        return view
    }()
    public init(model: Daily) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIs()
        makeConstaints()
        detailLabel.text = self.model?.weather?.first?.description
        // Do any additional setup after loading the view.
    }
    
    private func setupUIs() {
        extendedLayoutIncludesOpaqueBars = false
        view.backgroundColor = UIColor.white
        view.addSubview(detailLabel)
    }

    private func makeConstaints() {
        detailLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
