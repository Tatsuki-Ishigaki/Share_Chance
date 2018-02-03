//SecondViewController


import UIKit
import RealmSwift

class SecondViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate{
    
    var realm: Realm!

    let pickerView = UIPickerView()
    
    var editingTextField: UITextField!
    
    var pickOption = ["自動車", "仕事", "音楽", "スポーツ", "テレビ"]
    
    var pickOption2 = ["ちょっと好き", "好き", "とても好き", "1番好き", "愛してる"]
    
    
    @IBOutlet weak var Text: UITextField!
    
    @IBOutlet weak var pickerTextField: UITextField!
    
    @IBOutlet weak var pickerTextField2: UITextField!
    
    
    
    @IBAction func goBack(_ segue:UIStoryboardSegue) {}
    
    @IBAction func goSegue1(_ sender:UIButton) {
        performSegue(withIdentifier: "Button", sender: nil)
        
        let item = Item()
        
        item.title = Text.text!
        item.category = pickerTextField.text!
        item.like = pickerTextField2.text!
        
        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(item)
                print("Saved")
                print(Realm.Configuration.defaultConfiguration.fileURL!)
            })
        }catch{
            print("Save is Faild")
        }
        
        Text.text = ""
        pickerTextField.text = ""
        pickerTextField2.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(SecondViewController.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SecondViewController.canclePressed))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        Text.delegate = self
        Text.inputAccessoryView = toolBar
        
        pickerTextField.delegate = self
        pickerTextField.inputView = pickerView
        pickerTextField.inputAccessoryView = toolBar
        
        pickerTextField2.delegate = self
        pickerTextField2.inputView = pickerView
        pickerTextField2.inputAccessoryView = toolBar
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextField = textField
        pickerView.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if editingTextField == pickerTextField {
            return pickOption.count
        } else if editingTextField == pickerTextField2 {
            return pickOption2.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if editingTextField == pickerTextField {
            return pickOption[row]
        } else if editingTextField == pickerTextField2 {
            return pickOption2[row]
        }else{
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if editingTextField == pickerTextField {
            return pickerTextField.text = pickOption[row]
        } else if editingTextField == pickerTextField2 {
            return pickerTextField2.text = pickOption2[row]
        }
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @objc func canclePressed(sender: UIBarButtonItem) {
        if editingTextField == pickerTextField {
            pickerTextField.text = ""
        } else if editingTextField == pickerTextField2 {
            pickerTextField2.text = ""
        }
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ Text: UITextField) -> Bool {
        Text.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Text.resignFirstResponder()
        self.view.endEditing(true)
    }
    
}
