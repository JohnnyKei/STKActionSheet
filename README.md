# STKActionSheet

Modal Action Sheet.
![image](./image/image.gif)

# Usage
Use like UIAlertController.
Enable to set image.
Enable to configure label.
```
let actionSheet = ActionSheetController()
let checkAction = ActionSheetAction(title: "保存する", image: nil, handler: { [weak self] (action) in
})
actionSheet.addAction(checkAction)
let trashAction = ActionSheetAction(title: "削除する", image: #imageLiteral(resourceName: "trash"), configurationHandler: { (label) in
    label.textColor = UIColor.red
    label.font = UIFont.boldSystemFont(ofSize: 14)
}) { [weak self] (_) in

}
actionSheet.addAction(trashAction)
present(actionSheet, animated: true, completion: nil)
```
