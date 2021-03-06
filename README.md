# π³ creditCard-iOS-practice

<img width="300" alt="αα³αα³αα΅α«αα£αΊ" src="https://user-images.githubusercontent.com/28912774/147460907-89c96757-b962-47c1-9964-98e8f7a946ff.gif">

## π κΈ°λ₯ μμΈ

- Firebase realtime, fireStore DB κΈ°λ₯μ μ¬μ©νμ¬ μΉ΄λμΆμ² νμ΄μ§ λ₯Ό λ§λ­λλ€

- Firebase μμ λ°μ΄ν°λ₯Ό μ£Όκ³  λ°λ κ³Όμ μ μ°μ΅ν©λλ€

## π Pod library

### π· Kingfisher library

- μ΄λ―Έμ§ μλ²μμ μ΄λ―Έμ§λ₯Ό κ°μ Έλ€κ° UIμ κ°μ Έλ€κ° νμ ν΄μ€λ μ¬μ©λλ μ΄λ―Έμ§ μ²λ¦¬ μ€ν λΌμ΄λΈλ¬λ¦¬ μλλ€

> Kingfisher cheatSheet - https://github.com/onevcat/Kingfisher/wiki/Cheat-Sheet

#### μ€μΉ

`pod init`

```ruby
  # Pods for 09_creditCardList
  pod 'Kingfisher'
end
```

`pod install`

#### μ¬μ©λ²

```swift
//  CardListViewController.swift

// URL νμμΌλ‘ νμλ³νν¨
let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
// Kingfisher λ₯Ό μ¬μ©ν΄μ UIμ image νμ
cell.cardImageView.kf.setImage(with: imageURL)
```

### π· Lottie library

> Lottie-ios Github - https://github.com/airbnb/lottie-ios

- Lottie λ κΈ°λ³Έμ μΌλ‘ λ°±ν° κΈ°λ° μ λλ©λ―Έμκ³Ό μνΈλ₯Ό μ€μκ°μΌλ‘ λλλ§νλ Airbnb μμ κ°λ°ν μ€ν μμ€ μ λλ©μ΄μ λΌμ΄λΈλ¬λ¦¬ μλλ€

- Lottie λ₯Ό `bodymovin JSON` νμμΌλ‘ λ³΄λΈ μλ―Έλ©μ΄μμ μ§μν©λλ€

#### μ€μΉ

```ruby
  # Pods for 09_creditCardList
  pod 'lottie-ios'
end
```

`pod install`

### μ¬μ©λ²

- storyBoard μμ μλλ©μ΄μμ΄ λ³΄μ¬ μ§λ κ³³μ view object λ₯Ό μ§μ νκ³ , class μ€μ μ AnimationView μΌλ‘ μ§μ ν©λλ€

![image](https://user-images.githubusercontent.com/28912774/147317043-688d5db7-d22e-4975-8974-161107f156fc.png)

```swift
// in CardDetailViewController.swift

override func viewDidLoad() {
  super.viewDidLoad()

  // lottie animation μ μΈ (name μ lottie λ‘ λΆλ¬μ¬ json νμΌ μ΄λ¦μΌλ‘)
  let animationView = AnimationView(name: "card")
  lottieView.contentMode = .scaleAspectFit // μ΄λ―Έμ§ container μ¬μ΄μ¦μ λ§μΆκΈ°
  lottieView.addSubview(animationView)
  animationView.frame = lottieView.bounds
  animationView.loopMode = .loop // animation μ΄ κ³μ λ°λ³΅
  animationView.play() // animation μμ
}
```

![Kapture 2021-12-24 at 14 13 33](https://user-images.githubusercontent.com/28912774/147319304-d31febc0-2673-4d81-a551-2f9a80fcfa5c.gif)

## π Check Point !

### π· UI Structure

![image](https://user-images.githubusercontent.com/28912774/147461053-3d7bfc13-6428-470a-b744-82f94bcc00a7.png)

- CardListCell μ `.xib` νμΌλ‘ μμ±

![image](https://user-images.githubusercontent.com/28912774/147461212-fbd2f93f-b6b1-4799-88a7-bd5a6931b76d.png)

![image](https://user-images.githubusercontent.com/28912774/147463794-da169f0a-0c8d-44c0-8cb1-e47c0d9c8a7f.png)

### π· Model

```swift
import Foundation

struct CreditCard: Codable {
	let id: Int
	let rank: Int
	let name: String
	let cardImageURL: String
	let promotionDetail: PromotionDetail
	let isSelected: Bool? // μ¬μ©μκ° μΉ΄λλ₯Ό μ ν νμ λ, μμ±μ΄ λ¨ κ·Έμ μλ nil μ΄λκΉ optional μ€μ 
}

struct PromotionDetail: Codable {
	let companyName: String
	let amount: Int
	let period: String
	let benefitDate: String
	let benefitDetail: String
	let benefitCondition: String
	let condition: String
}

```

### π· Firebase Firestore

#### Firebase Firestore μ€μΉ

> Get started with Cloud Firestore - https://firebase.google.com/docs/firestore/quickstart#ios+

```ruby
  # Pods for 09_creditCardList
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
```

`pod install`

#### Firebase firestore μ λ°μ΄ν° μλ ₯

- firestore μλ json νμΌμ web console μ ν΅ν΄μ νλ²μ λ°λ‘ μλ ₯νλ κΈ°λ₯μ΄ μκΈ° λλ¬Έμ code swift μμ dummy data λ₯Ό import νλ κ³Όμ μ κ±°μ ΈμΌ ν©λλ€.

```swift
// in CreditCardDummy.swift

import Foundation

struct CreditCardDummy {
    static let card0 = CreditCard(id: 0, rank: 1, name: "μ νμΉ΄λ", cardImageURL: "https://www.shinhancard.com/_ICSFiles/afieldfile/2019/04/26/190426_pc_mrlife_cardplate600x380.png", promotionDetail: PromotionDetail(companyName: "μ ν", period: "2023.01.07(λͺ©)~2023.01.31(ν )", amount: 13, condition: "μ¨λΌμΈ μ±λμ ν΅ν΄ μ΄λ²€νΈ μΉ΄λλ₯Ό λ³΄μ νκ³ , ννμ‘°κ±΄μ μΆ©μ‘±νμ  λΆ", benefitCondition: "μ΄λ²€νΈ μΉ΄λλ‘ κ²°μ ν κΈμ‘μ΄ ν©ν΄μ 10λ§μμ΄μ κ²°μ ", benefitDetail: "νκΈ 10λ§μ", benefitDate: "2023.03.01(μ)μ΄ν"), isSelected: nil)
    static let card1 = CreditCard(id: 1
		......
```

```swift
// in AppDelegate.swift

import FirebaseFirestoreSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// firebase init
		FirebaseApp.configure()

		// firebase db μ μΈ
		let db = Firestore.firestore()
		// collection μμ creditCardList λ₯Ό μ°Ύκ³ , snapshot κ³Ό error λ₯Ό λΆλ¬μ΄(ν΄λΉ dbμ λ°μ΄ν°κ° μμ κ²½μ°μ νλ²μ λ°μ΄ν°λ₯Ό λ£μ΄ μ£Όλ κ²½μ° μ¬μ©)
		db.collection("creditCardList").getDocuments { snapshot, _ in
			guard snapshot?.isEmpty == true else { return } // snapshot μΌλ‘ dbκ° λΉμ΄ μλ μνμμλ§ ture λ‘ μ€μ 
			let batch = db.batch()

			let card0Ref = db.collection("creditCardList").document("card0")
			let card1Ref = db.collection("creditCardList").document("card1")
			let card2Ref = db.collection("creditCardList").document("card2")
			let card3Ref = db.collection("creditCardList").document("card3")
			let card4Ref = db.collection("creditCardList").document("card4")
			let card5Ref = db.collection("creditCardList").document("card5")
			let card6Ref = db.collection("creditCardList").document("card6")
			let card7Ref = db.collection("creditCardList").document("card7")
			let card8Ref = db.collection("creditCardList").document("card8")
			let card9Ref = db.collection("creditCardList").document("card9")

			do {
				try batch.setData(from: CreditCardDummy.card0, forDocument: card0Ref)
				try batch.setData(from: CreditCardDummy.card1, forDocument: card1Ref)
				try batch.setData(from: CreditCardDummy.card2, forDocument: card2Ref)
				try batch.setData(from: CreditCardDummy.card3, forDocument: card3Ref)
				try batch.setData(from: CreditCardDummy.card4, forDocument: card4Ref)
				try batch.setData(from: CreditCardDummy.card5, forDocument: card5Ref)
				try batch.setData(from: CreditCardDummy.card6, forDocument: card6Ref)
				try batch.setData(from: CreditCardDummy.card7, forDocument: card7Ref)
				try batch.setData(from: CreditCardDummy.card8, forDocument: card8Ref)
				try batch.setData(from: CreditCardDummy.card9, forDocument: card9Ref)
			} catch let error {
				print("ERROR: wirting card to Firestore \(error.localizedDescription)")
			}
			// batch μ commit μ ν΄μ£Όμ΄μΌμ§ data κ° μΆκ°κ° λ¨
			batch.commit()
		}
		return true
	}
```

- app build νμ firestore μμ data κ° import λ κ²μ νμΈ ν  μ μμ΅λλ€

![image](https://user-images.githubusercontent.com/28912774/147425834-4416f895-039b-4a4a-a6e1-0c176e1cbecd.png)

##### firebase Firestore μ½κΈ°

```swift
import UIKit
import Kingfisher
import FirebaseFirestore



// UITableViewController λ UITableView μ νμν delegate source λ₯Ό κΈ°λ³Έ μ°κ²°λ μνλ‘ μ κ³΅νκΈ° λλ¬Έμ λ³λλ‘ delegate μ μΈμ νμ§ μμλ λ¨
// λ, rootView λ‘ UItableView λ₯Ό κ°μ§κ² λ©λλ€
class CardListViewController: UITableViewController {

	// DB μ μΈ
	var db = Firestore.firestore()

	// MARK: Variable
	var creditCardList: [CreditCard] = []

	// MARK: LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()

		// UITabelView Cell Register
		let nibName = UINib(nibName: "CardListCell", bundle: nil)
		tableView.register(nibName, forCellReuseIdentifier: "CardListCell")

		// firestore μ½κΈ° code μΆκ°
		db.collection("creditCardList").addSnapshotListener { snapshot , error in
			guard let documents = snapshot?.documents else {
				// κ°μ΄ μμ κ²½μ°μ error μ²λ¦¬
				print("ERROR Firesotre fetching document \(String(describing: error))")
				return
			}
			// λ°μ΄ν° μ²λ¦¬ : compactMap μ μ¬μ©νλ κ²μ nil κ°μ λ°°μ΄ μμ λ£μ§ μκ² νμ§ μν΄μ
			self.creditCardList = documents.compactMap { doc -> CreditCard? in
				do {
					let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
					let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
					return creditCard
				} catch let error {
					print("ERROR JSON Parsing \(error)")
					return nil
				}
			}.sorted { $0.rank < $1.rank }

			// main tread μμ λμκ°λ tableView reload
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
}
```

<img width="300" alt="αα³αα³αα΅α«αα£αΊ" src="https://user-images.githubusercontent.com/28912774/147428407-2131082e-a8a0-444e-801a-07d9c945e793.png">

##### firebase Firestore μ°κΈ°

- struct model μ μλ `isSelected: Bool?` μ κ°μ ν΅ν΄ μ νλλ©΄ select κ° λκ²λ firestore μ κ° μλ ₯νκΈ° μλλ€

- νμΌμ κ²½λ‘λ₯Ό μλμ λͺ¨λ₯Όλ λκ°μ§ κ²½μ°μ μμ λ°λΌ code λ°©μμ΄ λ€λ¦

```swift
// in CardListViewController.swift

// didSelectRowAt: cell μ μ ν νμλ, CardDetailViewController λ‘ λμ΄κ°λ action
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	// μμΈνλ©΄ μ λ¬
	let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
	guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "CardDetailViewController") as? CardDetailViewController else { return }
	detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
	self.show(detailViewController, sender: nil)

	// Firestore λ°μ΄ν° μ°κΈ°
	// option1 : κ²½λ‘λ₯Ό μκ³  μμ κ²½μ°
	let cardID = creditCardList[indexPath.row].id
	db.collection("creditCardList").document("card\(cardID)").updateData(["isSelected": true])

	// option2: κ²½λ‘λ₯Ό λͺ¨λ₯΄κ³  μμ κ²½μ°
	// id κ°μ κ²μνλ€μμ κ·Έ κ²°κ³Όλ‘ μ°Ύμ λ¬Έμμ μλ°μ΄νΈ ν΄μ€μΌν¨
	db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
		guard let document = snapshot?.documents.first else {
			// error μ²λ¦¬
			print("ERROR Firestore fetching document")
			return
		}
		// cardID κ° μλ€λ©΄
		document.reference.updateData(["isSelected": true])
	}
}
```

ν­λͺ©μ ν΄λ¦­ν κ°μ data field μ `isSelected: true` κ° μμ±λ¨μ νμΈ

![image](https://user-images.githubusercontent.com/28912774/147440455-a73e1f75-6399-443d-851e-fe8fd9c45290.png)

##### firebase Firestore μ­μ 

```swift
// in CardListViewController.swift

// forRowAt: cell delete
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
	if editingStyle == .delete {

		// firestore μ μ­μ 
		// Option 1: κ²½λ‘λ₯Ό μκ³  μμλ
		let cardID = creditCardList[indexPath.row].id
		// db.collection("creditCardList").document("card\(cardID)").delete()

		// Option 2: κ²½λ‘λ₯Ό λͺ¨λ₯΄κ³  μμλ : wherefield method λ₯Ό ν΅ν΄ λ¬Έμ μ μ²΄λ₯Ό κ²μν νμ snpshot μ μ κ³΅ν¨
		db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
			guard let document = snapshot?.documents.first else {
				print("ERROR")
				return
			}
			document.reference.delete()
		}
	}
}
```

### π· Firebase Realtime DB

- Realtime DB λ λ¨μΌ json νμΌμ κ΄λ¦¬ νκΈ°μ μ©μν DB μλλ€ (json import κΈ°λ₯ μ§μ)

#### Firebase Realtime DB μ€μΉ

```ruby
  # Pods for 09_creditCardList
 	pod 'Firebase/Database'
```

`pod install`

#### Firebase Realtime DB μ½κΈ°

```swift
//  CardListViewController.swift
import FirebaseDatabase

class CardListViewController: UITableViewController {

	var ref: DatabaseReference!  // Firebase Realtime DB μ°Έμ‘° λ³μ

// MARK: Firebase Realtime DB READ
/*Firebase Database μ½κΈ°*/
self.ref = Database.database().reference()

self.ref.observe(.value) { snapshot in
	guard let value = snapshot.value as? [String: [String: Any]] else { return }
	do {
		let jsonData = try JSONSerialization.data(withJSONObject: value)
		let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
		let cardList = Array(cardData.values)
		self.creditCardList = cardList.sorted { $0.rank < $1.rank }

		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	} catch let error {
		print("Error json parsing \(error)")
	}
}
```

![image](https://user-images.githubusercontent.com/28912774/147459633-64160456-1b1c-4845-bd6d-ade1791386e9.png)

#### Firebase Realtime DB μ°κΈ°

```swift
// in CardListViewController.swift

// MARK: Firebase realtime DB Write
		 let cardID = creditCardList[indexPath.row].id
		 //option1: κ²½λ‘λ₯Ό μλ κ²½μ°μ μ°κΈ°
		 self.ref.child("Item\(cardID)/isSelected").setValue(true)
		 //option2: κ²½λ‘λ₯Ό λͺ¨λ₯΄λ κ²½μ°
		 self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
		 guard let self = self,
		 let value = snapshot.value as? [String: [String: Any]],
		 let key = value.keys.first else { return }

		 self.ref.child("\(key)/isSelected").setValue(true)
		 }
```

#### Firebase Realtime DB μ­μ 

```swift
	// forRowAt: cell delete
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
	if editingStyle == .delete {

	// MARK: Firebase realtime DB Delete
		let cardID = creditCardList[indexPath.row].id
		self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
		guard let self = self,
		let value = snapshot.value as? [String: [String: Any]],
		let key = value.keys.first else { return }

		self.ref.child(key).removeValue()
		}
		...
```

> Describing check point in details in Jacob's DevLog - https://jacobko.info/firebaseios/ios-firebase-02/

<!-- ## β Error Check Point

### πΆ -->

<!-- xcode Mark template -->

<!--
// MARK: IBOutlet
// MARK: LifeCycle
// MARK: Actions
// MARK: Methods
// MARK: Extensions
-->

---

πΆ π· π π π

## π Reference

Jacob's DevLog - [https://jacobko.info/firebaseios/ios-firebase-02/](https://jacobko.info/firebaseios/ios-firebase-02/)

LEEO TIL Dev Log - [https://dev200ok.blogspot.com/2020/09/ios-kingfisher.html](https://dev200ok.blogspot.com/2020/09/ios-kingfisher.html)

iOSμμ Lottie μ λλ©μ΄μ μμνκΈ° - [https://ichi.pro/ko/ioseseo-lottie-aenimeisyeon-sijaghagi-29592323663035](https://ichi.pro/ko/ioseseo-lottie-aenimeisyeon-sijaghagi-29592323663035)

fastcampus - [https://fastcampus.co.kr/dev_online_iosappfinal](https://fastcampus.co.kr/dev_online_iosappfinal)
