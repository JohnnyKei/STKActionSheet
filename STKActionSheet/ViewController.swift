//
//  ViewController.swift
//  STKActionSheet
//
//  Created by SatoKei on 2018/11/22.
//  Copyright © 2018 kei.sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showActionSheet() {
        let actionSheet = ActionSheetController()
        let checkAction = ActionSheetAction(title: "保存する", image: nil, handler: { [weak self] (action) in
        })
        actionSheet.addAction(checkAction)
        let trashAction = ActionSheetAction(title: "削除する", image: #imageLiteral(resourceName: "trash"), configurationHandler: { (label) in
        }) { [weak self] (_) in

        }
        actionSheet.addAction(trashAction)
        present(actionSheet, animated: true, completion: nil)
    }

}

