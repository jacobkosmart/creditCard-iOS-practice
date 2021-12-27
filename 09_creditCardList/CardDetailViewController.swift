//
//  CardDetailViewController.swift
//  09_creditCardList
//
//  Created by Jacob Ko on 2021/12/24.
//

import UIKit
import Lottie

class CardDetailViewController: UIViewController {
	
	// MARK: Variable
	var promotionDetail: PromotionDetail?
	
	// MARK: IBOutlet
	
	@IBOutlet weak var lottieView: AnimationView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var periodLabel: UILabel!
	@IBOutlet weak var conditionLabel: UILabel!
	@IBOutlet weak var benefitConditionLabel: UILabel!
	@IBOutlet weak var benefitDetailLabel: UILabel!
	@IBOutlet weak var benefitDateLabel: UILabel!
	
	// MARK: LifeCycle
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// 받아온 데이터를 각각의 label에 적절히 넣어주기
		guard let detail = promotionDetail else { return }
		titleLabel.text = """
			\(detail.companyName) 카드쓰면
			\(detail.amount) 만원을 드려요.
		"""
		periodLabel.text = detail.period
		conditionLabel.text = detail.condition
		benefitDateLabel.text = detail.benefitCondition
		benefitDetailLabel.text = detail.benefitDetail
		benefitDateLabel.text = detail.benefitDate
	}
	
}


// MARK: Actions
// MARK: Methods
// MARK: Extensions
