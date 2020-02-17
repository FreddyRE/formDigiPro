//
//  ItemListVC.swift
//  form_digitPro_2
//
//  Created by Freddy Romero Espinosa on 2/15/20.
//  Copyright © 2020 Freddy Romero Espinosa. All rights reserved.
//

import UIKit
import SQLite3


class ItemListVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    var tableView = UITableView()
    var items: [ItemInput] = []
    var mainTitle: UILabel = UILabel()
    static var registerButton: UIButton = UIButton()
    static var isActiveButton = false {
        didSet {
            if(self.isActiveButton == true){
                activateNextButton()
            } else {
                disableeNextButton()
            }
            
        }
    }
        
    static var wasSavedDataCorrectly:Bool? {
        didSet {
            clearDataInFields();
        }
    }
    
    
    var db:DBHelper = DBHelper()
        
    
    struct cellIdentifier {
        static let idCell = "cellId"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        items = getDataForCells()
        configureTableView()
        customizeFirstView(withWidth: self.view.bounds.width)
        

        // Do any additional setup after loading the view.
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.register(itemListCell.self, forCellReuseIdentifier: cellIdentifier.idCell)
        tableView.rowHeight = 100
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        //tableView.pin(to: view)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: self.view.bounds.size.width/4, width: self.view.bounds.width, height: self.view.bounds.size.height-self.view.bounds.size.width*1/2)
        
        self.tableView.contentInset = UIEdgeInsets(top: (self.tableView.frame.height-self.tableView.rowHeight*5)/2, left: 10, bottom: (self.tableView.frame.height-self.tableView.rowHeight*5)/2, right: 10)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
       
                   
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.idCell) as! itemListCell
        let itemActive = items[indexPath.row]
        cell.set(item: itemActive)
        return cell
    }
    
   
    func getDataForCells() -> [ItemInput] {
                
        var itemArray = [ItemInput]()
        
        itemArray.append(ItemInput(image: ImagesIcons.name!, title: "Nombre", tag:InputsStyle.name.rawValue))
        itemArray.append(ItemInput(image: ImagesIcons.name!, title: "Apellido Paterno", tag: InputsStyle.lastName.rawValue))
        itemArray.append(ItemInput(image: ImagesIcons.name!, title: "Apellido Materno", tag: InputsStyle.secondLastName.rawValue))
        itemArray.append(ItemInput(image: ImagesIcons.mail!, title: "Correo electrónico", tag: InputsStyle.email.rawValue))
        itemArray.append(ItemInput(image: ImagesIcons.phone!, title: "Telefono celular", tag: InputsStyle.phone.rawValue ))
        
        return itemArray
    }
    
    func customizeFirstView(withWidth width:CGFloat) {
        view.backgroundColor = .white
        mainTitle.frame = CGRect(x: 0, y: width/4, width: width, height: 50)
        mainTitle.text = "Hola."
        mainTitle.font = UIFont(name: "MarkerFelt-Wide", size: 60)
        view.addSubview(mainTitle)
        
        let NSmainTitle = mainTitle.text as NSString?
        
        //change color of dot in main title
              
        let changeColorAttribute = NSMutableAttributedString.init(string: mainTitle.text!)
        changeColorAttribute.addAttribute(.foregroundColor, value: UIColor.blue, range: (NSmainTitle?.range(of: "."))!)
              
        mainTitle.attributedText = changeColorAttribute
            
        //Button for Next
        ItemListVC.registerButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        ItemListVC.registerButton.frame.origin = CGPoint(x: view.frame.width/2 - ItemListVC.self.registerButton.frame.width/2, y: view.frame.height-ItemListVC.registerButton.frame.height*2)
        ItemListVC.registerButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        ItemListVC.registerButton.setTitle("Siguiente", for: .normal)
        ItemListVC.registerButton.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 1, alpha: 0.3), for: .normal)
        ItemListVC.registerButton.addTarget(self, action: #selector(saveInDBAction), for: .touchUpInside)
        ItemListVC.registerButton.isEnabled = false
        ItemListVC.registerButton.layer.cornerRadius = 10
        view.addSubview(ItemListVC.registerButton)
        
        //Draw a triangle at top
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x:0, y: width/4))
        path.addLine(to: CGPoint(x:width, y:0))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.blue.cgColor

        self.view.layer.insertSublayer(shape, at: 0)
        
        
    }
    

    @objc private func keyboardWillShow(notification: NSNotification) {
        
        tableView.isScrollEnabled = true
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height-100, right: 0)
            

        }

        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tableView.contentInset = UIEdgeInsets(top:100, left:0, bottom:0, right:0)
        }

    }
    
    @objc func saveInDBAction() {
        
        let activeID = db.readId()
                        
        db.insert(id: Int(activeID+1), name: ValueInput.name, lastName: ValueInput.lastName, secondLastName: ValueInput.secondLastName, email: ValueInput.email, phone: ValueInput.phone)

    }
    
    static func activateNextButton() {
        
        registerButton.isEnabled = true
        registerButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(1.0)
        registerButton.setTitleColor(UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1.0), for: .normal)

    }
    static func disableeNextButton() {
        
        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        registerButton.setTitleColor(UIColor(displayP3Red: 0, green: 0, blue: 1, alpha: 0.3), for: .normal)

        
    }
    
    
    
    static func clearDataInFields(){
        

    }
    
    

}
