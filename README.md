# 💳 creditCard-iOS-practice

<img width="300" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/147460907-89c96757-b962-47c1-9964-98e8f7a946ff.gif">

## 📌 기능 상세

- Firebase realtime, fireStore DB 기능을 사용하여 카드추천 페이지 를 만듭니다

- Firebase 에서 데이터를 주고 받는 과정을 연습합니다

## 👉 Pod library

### 🔷 Kingfisher library

- 이미지 서버에서 이미지를 가져다가 UI에 가져다가 표시 해줄때 사용되는 이미지 처리 오픈 라이브러리 입니다

> Kingfisher cheatSheet - https://github.com/onevcat/Kingfisher/wiki/Cheat-Sheet

#### 설치

`pod init`

```ruby
  # Pods for 09_creditCardList
  pod 'Kingfisher'
end
```

`pod install`

#### 사용법

```swift
//  CardListViewController.swift

// URL 타입으로 타입변환함
let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
// Kingfisher 를 사용해서 UI에 image 표시
cell.cardImageView.kf.setImage(with: imageURL)
```

### 🔷 Lottie library

> Lottie-ios Github - https://github.com/airbnb/lottie-ios

- Lottie 는 기본적으로 백터 기반 애니메미션과 아트를 실시간으로 랜더링하는 Airbnb 에서 개발한 오픈 소스 애니메이션 라이브러리 입니다

- Lottie 를 `bodymovin JSON` 형식으로 보낸 에미메이션을 지원합니다

#### 설치

```ruby
  # Pods for 09_creditCardList
  pod 'lottie-ios'
end
```

`pod install`

### 사용법

- storyBoard 에서 에니메이션이 보여 지는 곳에 view object 를 지정하고, class 설정을 AnimationView 으로 지정합니다

![image](https://user-images.githubusercontent.com/28912774/147317043-688d5db7-d22e-4975-8974-161107f156fc.png)

```swift
// in CardDetailViewController.swift

override func viewDidLoad() {
  super.viewDidLoad()

  // lottie animation 선언 (name 은 lottie 로 불러올 json 파일 이름으로)
  let animationView = AnimationView(name: "card")
  lottieView.contentMode = .scaleAspectFit // 이미지 container 사이즈에 맞추기
  lottieView.addSubview(animationView)
  animationView.frame = lottieView.bounds
  animationView.loopMode = .loop // animation 이 계속 반복
  animationView.play() // animation 시작
}
```

![Kapture 2021-12-24 at 14 13 33](https://user-images.githubusercontent.com/28912774/147319304-d31febc0-2673-4d81-a551-2f9a80fcfa5c.gif)

## 🔑 Check Point !

### 🔷 UI Structure

![image](https://user-images.githubusercontent.com/28912774/147461053-3d7bfc13-6428-470a-b744-82f94bcc00a7.png)

- CardListCell 은 `.xib` 파일로 작성

![image](https://user-images.githubusercontent.com/28912774/147461212-fbd2f93f-b6b1-4799-88a7-bd5a6931b76d.png)

![image](https://user-images.githubusercontent.com/28912774/147463794-da169f0a-0c8d-44c0-8cb1-e47c0d9c8a7f.png)

### 🔷 Model

```swift
import Foundation

struct CreditCard: Codable {
	let id: Int
	let rank: Int
	let name: String
	let cardImageURL: String
	let promotionDetail: PromotionDetail
	let isSelected: Bool? // 사용자가 카드를 선택 했을 때, 생성이 됨 그전에는 nil 이니까 optional 설정
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

### 🔷 Firebase Firestore

#### Firebase Firestore 설치

> Get started with Cloud Firestore - https://firebase.google.com/docs/firestore/quickstart#ios+

```ruby
  # Pods for 09_creditCardList
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
```

`pod install`

#### Firebase firestore 에 데이터 입력

- firestore 에는 json 파일을 web console 을 통해서 한번에 바로 입력하는 기능이 없기 때문에 code swift 에서 dummy data 를 import 하는 과정을 거져야 합니다.

```swift
// in CreditCardDummy.swift

import Foundation

struct CreditCardDummy {
    static let card0 = CreditCard(id: 0, rank: 1, name: "신한카드", cardImageURL: "https://www.shinhancard.com/_ICSFiles/afieldfile/2019/04/26/190426_pc_mrlife_cardplate600x380.png", promotionDetail: PromotionDetail(companyName: "신한", period: "2023.01.07(목)~2023.01.31(토)", amount: 13, condition: "온라인 채널을 통해 이벤트 카드를 보유하고, 혜택조건을 충족하신 분", benefitCondition: "이벤트 카드로 결제한 금액이 합해서 10만원이상 결제", benefitDetail: "현금 10만원", benefitDate: "2023.03.01(월)이후"), isSelected: nil)
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

		// firebase db 선언
		let db = Firestore.firestore()
		// collection 에서 creditCardList 를 찾고, snapshot 과 error 를 불러옴(해당 db에 데이터가 없을 경우에 한번에 데이터를 넣어 주는 경우 사용)
		db.collection("creditCardList").getDocuments { snapshot, _ in
			guard snapshot?.isEmpty == true else { return } // snapshot 으로 db가 비어 있는 상태에서만 ture 로 설정
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
			// batch 에 commit 을 해주어야지 data 가 추가가 됨
			batch.commit()
		}
		return true
	}
```

- app build 후에 firestore 에서 data 가 import 된 것을 확인 할 수 있습니다

![image](https://user-images.githubusercontent.com/28912774/147425834-4416f895-039b-4a4a-a6e1-0c176e1cbecd.png)

##### firebase Firestore 읽기

```swift
import UIKit
import Kingfisher
import FirebaseFirestore



// UITableViewController 는 UITableView 에 필요한 delegate source 를 기본 연결된 상태로 제공하기 때문에 별도로 delegate 선언을 하지 않아도 됨
// 또, rootView 로 UItableView 를 가지게 됩니다
class CardListViewController: UITableViewController {

	// DB 선언
	var db = Firestore.firestore()

	// MARK: Variable
	var creditCardList: [CreditCard] = []

	// MARK: LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()

		// UITabelView Cell Register
		let nibName = UINib(nibName: "CardListCell", bundle: nil)
		tableView.register(nibName, forCellReuseIdentifier: "CardListCell")

		// firestore 읽기 code 추가
		db.collection("creditCardList").addSnapshotListener { snapshot , error in
			guard let documents = snapshot?.documents else {
				// 값이 없을 경우에 error 처리
				print("ERROR Firesotre fetching document \(String(describing: error))")
				return
			}
			// 데이터 처리 : compactMap 을 사용하는 것을 nil 값을 배열 안에 넣지 않게 하지 위해서
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

			// main tread 에서 돌아가는 tableView reload
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
}
```

<img width="300" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/147428407-2131082e-a8a0-444e-801a-07d9c945e793.png">

##### firebase Firestore 쓰기

- struct model 에 있는 `isSelected: Bool?` 을 갑을 통해 선택되면 select 가 되게끔 firestore 에 값 입력하기 입니다

- 파일의 경로를 알때와 모를때 두가지 경우에 수에 따라 code 방식이 다름

```swift
// in CardListViewController.swift

// didSelectRowAt: cell 을 선택 했을때, CardDetailViewController 로 넘어가는 action
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	// 상세화면 전달
	let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
	guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "CardDetailViewController") as? CardDetailViewController else { return }
	detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
	self.show(detailViewController, sender: nil)

	// Firestore 데이터 쓰기
	// option1 : 경로를 알고 있을 경우
	let cardID = creditCardList[indexPath.row].id
	db.collection("creditCardList").document("card\(cardID)").updateData(["isSelected": true])

	// option2: 경로를 모르고 있을 경우
	// id 값을 검색한다음에 그 결과로 찾은 문서에 업데이트 해줘야함
	db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
		guard let document = snapshot?.documents.first else {
			// error 처리
			print("ERROR Firestore fetching document")
			return
		}
		// cardID 가 있다면
		document.reference.updateData(["isSelected": true])
	}
}
```

항목을 클릭한 값에 data field 에 `isSelected: true` 가 생성됨을 확인

![image](https://user-images.githubusercontent.com/28912774/147440455-a73e1f75-6399-443d-851e-fe8fd9c45290.png)

##### firebase Firestore 삭제

```swift
// in CardListViewController.swift

// forRowAt: cell delete
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
	if editingStyle == .delete {

		// firestore 의 삭제
		// Option 1: 경로를 알고 있을때
		let cardID = creditCardList[indexPath.row].id
		// db.collection("creditCardList").document("card\(cardID)").delete()

		// Option 2: 경로를 모르고 있을때 : wherefield method 를 통해 문서 전체를 검색한 후에 snpshot 을 제공함
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

### 🔷 Firebase Realtime DB

- Realtime DB 는 단일 json 파일을 관리 하기에 용의한 DB 입니다 (json import 기능 지원)

#### Firebase Realtime DB 설치

```ruby
  # Pods for 09_creditCardList
 	pod 'Firebase/Database'
```

`pod install`

#### Firebase Realtime DB 읽기

```swift
//  CardListViewController.swift
import FirebaseDatabase

class CardListViewController: UITableViewController {

	var ref: DatabaseReference!  // Firebase Realtime DB 참조 변수

// MARK: Firebase Realtime DB READ
/*Firebase Database 읽기*/
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

#### Firebase Realtime DB 쓰기

```swift
// in CardListViewController.swift

// MARK: Firebase realtime DB Write
		 let cardID = creditCardList[indexPath.row].id
		 //option1: 경로를 아는 경우에 쓰기
		 self.ref.child("Item\(cardID)/isSelected").setValue(true)
		 //option2: 경로를 모르는 경우
		 self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
		 guard let self = self,
		 let value = snapshot.value as? [String: [String: Any]],
		 let key = value.keys.first else { return }

		 self.ref.child("\(key)/isSelected").setValue(true)
		 }
```

#### Firebase Realtime DB 삭제

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

<!-- ## ❌ Error Check Point

### 🔶 -->

<!-- xcode Mark template -->

<!--
// MARK: IBOutlet
// MARK: LifeCycle
// MARK: Actions
// MARK: Methods
// MARK: Extensions
-->

---

🔶 🔷 📌 🔑 👉

## 🗃 Reference

Jacob's DevLog - [https://jacobko.info/firebaseios/ios-firebase-02/](https://jacobko.info/firebaseios/ios-firebase-02/)

LEEO TIL Dev Log - [https://dev200ok.blogspot.com/2020/09/ios-kingfisher.html](https://dev200ok.blogspot.com/2020/09/ios-kingfisher.html)

iOS에서 Lottie 애니메이션 시작하기 - [https://ichi.pro/ko/ioseseo-lottie-aenimeisyeon-sijaghagi-29592323663035](https://ichi.pro/ko/ioseseo-lottie-aenimeisyeon-sijaghagi-29592323663035)

fastcampus - [https://fastcampus.co.kr/dev_online_iosappfinal](https://fastcampus.co.kr/dev_online_iosappfinal)
