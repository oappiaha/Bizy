//
//  WalletController.swift
//  Bizy
//
//  Created by Wolf on 11/8/18.
//  Copyright © 2018 Wolf. All rights reserved.
//

import UIKit
import CoreData
//import Chameleon
import ChameleonFramework
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialColorScheme
import MaterialComponents.MaterialButtons_ButtonThemer

class WalletController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var profile: UIButton!
  @IBOutlet var profileBarButton: UIBarButtonItem!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var scanCode: MDCButton!
  @IBOutlet var qrCode: MDCButton!
  @IBOutlet weak var nameData: UILabel!
  @IBOutlet weak var tablesView: UITableView!
 
  var thisuser = User(fname: "", lname: "", email: "")
  var cards = [User]()
  var selfLoaded = false;
  var currentUser = User(fname: "", lname: "", email: "")
  var proPic = ["man.png", "woman.png", "wom.png"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
    self.tablesView.register(cellNib, forCellReuseIdentifier: "cell")
//    self.tablesView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    initChameleonColors()
    if (self.selfLoaded == false) {
      loadSelf()
      configureView()
    }
    loadCards()
    tablesView.reloadData()
    print(thisuser.firstName + " ...NOTHING OR SOMETHING??")
    print(cards.count)

  }
  
  func initChameleonColors() {
//    self.view.backgroundColor = UIColor.flatPowderBlue
//    self.tablesView.backgroundColor = UIColor.flatPowderBlue
    
    nameData.textColor = HexColor("E0C393")
    initializeLogos()
    initializeButtons()
    
  }
  
  func initializeButtons() {
    let colorSchemeScan = MDCSemanticColorScheme()
    colorSchemeScan.primaryColor = HexColor("A6DD69")!
    let colorSchemeCode = MDCSemanticColorScheme()
    colorSchemeCode.primaryColor = HexColor("E0C393")!

    
    let buttonSchemeScan = MDCButtonScheme()
    let buttonSchemeCode = MDCButtonScheme()
    MDCContainedButtonThemer.applyScheme(buttonSchemeScan, to: scanCode)
    MDCContainedButtonColorThemer.applySemanticColorScheme(colorSchemeScan, to: scanCode)
    
    
    MDCContainedButtonThemer.applyScheme(buttonSchemeCode, to: qrCode)
    MDCContainedButtonColorThemer.applySemanticColorScheme(colorSchemeCode, to: qrCode)

    
    
  }
  
  func initializeLogos() {
    let logo = UIImage(named: "title_2.png")
    let profile = UIImage(named: "resume.png")!.withRenderingMode(.alwaysOriginal)
    let bizyLogo = UIImageView(image:logo)
    let profileLogo = UIImageView(image: profile)
    profileBarButton.image = profile
    self.navigationItem.titleView = bizyLogo

  }
  
  @objc func tabBarTableauClicked(sender: UIBarButtonItem){
    performSegue(withIdentifier: "toProfile", sender: self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let selectedRow = tablesView.indexPathForSelectedRow {
      tablesView.deselectRow(at: selectedRow, animated: true)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  //MARK: Wallet Functions----------------------------
  func loadCards() {
    cards.removeAll()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
    request.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        self.loadCard(data: data)
      }
      
    } catch {
      
      print("Failed")
    }
  }
  
  func loadSelf() {
    //Possibly Move to View Did Appear
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
    request.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        self.loadUsers(data: data)
      }
      
    } catch {
      
      print("Failed")
    }
  }
  
  func loadCard(data: NSManagedObject){
    
    let newUser = User(fname: "", lname: "", email: "")
    newUser.firstName = (data.value(forKey: "first_name") as! String)
    newUser.lastName = (data.value(forKey: "last_name") as! String)
    newUser.email = (data.value(forKey: "email") as? String ?? "bop@gmil.com")
    newUser.phone = (data.value(forKey: "phone") as? String ?? "4083070736" )
    newUser.company = (data.value(forKey: "company") as? String ?? "Microsoft")
    newUser.position = (data.value(forKey: "position") as? String ?? "Intern")
    newUser.summary = (data.value(forKey: "summary") as? String ?? "I'm a developer")
    newUser.city = (data.value(forKey: "city") as? String ?? "")
    newUser.state = (data.value(forKey: "state") as? String ?? "")
    newUser.website = (data.value(forKey: "website") as? String ?? "")
    newUser.linkedIn = (data.value(forKey: "linkedin") as? String ?? "")
    
    let number = Int.random(in: 0 ... 2)
    newUser.photo = proPic[number]
    
    
    
    
    //Waiting for image information---------------------------------------------------------
//    newUser.resume = (data.value(forKey: "resume") as? String ?? "")
//    newUser.image = UIImage(data:(data.value(forKey: "image") as! NSData) as! Data)
    
       cards.append(newUser)

  }
  
  
  func loadUsers(data: NSManagedObject){
    let newUser = User(fname: "", lname: "", email: "")
    newUser.firstName = (data.value(forKey: "first_name") as! String)
    newUser.lastName = (data.value(forKey: "last_name") as! String)
    newUser.email = (data.value(forKey: "email") as? String ?? "bop@gmil.com")
    thisuser = newUser
  }
  
  func configureView() {
    if (thisuser.firstName.count > 0) {
      nameData.text = thisuser.firstName + "'s Wallet"
      self.selfLoaded = true;
      return
    } else {
      nameData.text = "Wallet"
    }
    
  }
  
  
  
  //Mark: TableView-----------------------------------------------------------------
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.currentUser = cards[indexPath.row]
    performSegue(withIdentifier: "toDetails", sender: currentUser)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cards.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    
    let card = cards[indexPath.row]
    let fullName = card.firstName + " " + card.lastName
    cell.name?.text = fullName
    cell.company?.text = card.company
    cell.position?.text = card.position
    cell.photo?.image = UIImage(named: card.photo!)
    
    
    let number = Int.random(in: 0 ... 2)
    if (card.photo != nil) {
        cell.photo?.image = UIImage(named: card.photo!)
    } else {
      cell.photo?.image = UIImage(named: proPic[number])
    }
    
    
    //Waiting for images-----------------------------------------------------------------
//    cell.imageView!.image = contact.image!.image
    return cell
  }
  

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      cards.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array,
      // and add a new row to the table view. However, not strictly needed here
      // given the segue automatically goes to add contact.
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Your code here
    if segue.identifier == "toDetails" {
      if let cardView = segue.destination as? CardDetailView {
        cardView.thisuser = self.currentUser
      }
      
    }
  
}

}

