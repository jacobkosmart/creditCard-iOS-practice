//
//  CardListViewController.swift
//  09_creditCardList
//
//  Created by Jacob Ko on 2021/12/24.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseFirestore



// UITableViewController 는 UITableView 에 필요한 delegate source 를 기본 연결된 상태로 제공하기 때문에 별도로 delegate 선언을 하지 않아도 됨
// 또, rootView 로 UItableView 를 가지게 됩니다
class CardListViewController: UITableViewController {
	
	var ref: DatabaseReference!     //Firebase Realtime Database
	var db = Firestore.firestore() // Firebase FireStore
	
	// MARK: Variable
	var creditCardList: [CreditCard] = []
	
	// MARK: LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// UITabelView Cell Register
		let nibName = UINib(nibName: "CardListCell", bundle: nil)
		tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
		
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
		
		// MARK: Firestore READ
		// // firestore 읽기 code 추가
		// db.collection("creditCardList").addSnapshotListener { snapshot , error in
		// 	guard let documents = snapshot?.documents else {
		// 		// 값이 없을 경우에 error 처리
		// 		print("ERROR Firesotre fetching document \(String(describing: error))")
		// 		return
		// 	}
		// 	// 데이터 처리 : compactMap 을 사용하는 것을 nil 값을 배열 안에 넣지 않게 하지 위해서
		// 	self.creditCardList = documents.compactMap { doc -> CreditCard? in
		// 		do {
		// 			let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
		// 			let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
		// 			return creditCard
		// 		} catch let error {
		// 			print("ERROR JSON Parsing \(error)")
		// 			return nil
		// 		}
		// 	}.sorted { $0.rank < $1.rank }
		// 	
		// 	// main tread 에서 돌아가는 tableView reload
		// 	DispatchQueue.main.async {
		// 		self.tableView.reloadData()
		// 	}
		// }
	}
}
	
	
	// MARK: tableView features
	// numberOfSections : tableSection 의 길이 지정
extension CardListViewController {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return creditCardList.count
	}
	
	// cellForRowAt
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
		
		cell.rankLabel.text = "\(creditCardList[indexPath.row].rank) 위"
		cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount) 만원 증정"
		cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
		
		// URL 타입으로 타입변환함
		let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
		// Kingfisher 를 사용해서 UI에 image 표시
		cell.cardImageView.kf.setImage(with: imageURL)
		
		return cell
	}
	
	//heightForRowAt:  cell 의 높이 지정
	override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	// didSelectRowAt: cell 을 선택 했을때, CardDetailViewController 로 넘어가는 action
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// 상세화면 전달
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let detailViewController = storyboard.instantiateViewController(withIdentifier: "CardDetailViewController") as? CardDetailViewController else { return }
		detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
		self.show(detailViewController, sender: nil)
		
		// MARK: Firebase realtime DB Write
		/*Firebase Database 쓰기
		 let cardID = creditCardList[indexPath.row].id
		 //option1
		 self.ref.child("Item\(cardID)/isSelected").setValue(true)
		 //option2
		 self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
		 guard let self = self,
		 let value = snapshot.value as? [String: [String: Any]],
		 let key = value.keys.first else { return }
		 
		 self.ref.child("\(key)/isSelected").setValue(true)
		 }
		 */
		
		
		// MARK: Firestore Write
		// Firestore 데이터 쓰기
		// option1 : 경로를 알고 있을 경우
		let cardID = creditCardList[indexPath.row].id
		// db.collection("creditCardList").document("card\(cardID)").updateData(["isSelected": true])
		
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
	
	// forRowAt: cell delete
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			
			// MARK: Firebase realtime DB Delete
			/*Firebase Realtime Database 삭제
			 let cardID = creditCardList[indexPath.row].id
			 self.ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
			 guard let self = self,
			 let value = snapshot.value as? [String: [String: Any]],
			 let key = value.keys.first else { return }
			 
			 self.ref.child(key).removeValue()
			 }
			 */
			
			// MARK: Firestore Delete
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
}


