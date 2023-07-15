//
//  ErrorView.swift
//

import Foundation
import UIKit

protocol RefreshDelegate: AnyObject {
    func refreshPage()
}

class ErrorView: UIView {

    weak var delegate: RefreshDelegate?

    // MARK: - Private properties

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()

    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "errorImage")
        imageView.tintColor = UIColor(named: "mainTextFontColor")
        return imageView
    }()

    private let errorTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong..."
        label.textColor = UIColor(named: "mainTextFontColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let secondaryTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Try to reload the page or re-enter the application."
        label.textColor = UIColor(named: "secondaryTextFontColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let refreshPageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitle("Refresh", for: .normal)
        button.addTarget(self, action: #selector(refreshPageButtonAction), for: .touchUpInside)
        return button
    }()

    @objc func refreshPageButtonAction() {
        delegate?.refreshPage()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private struct Constants {
        static let leading: CGFloat = 20
        static let trailing: CGFloat = 20

        static let stackViewTop: CGFloat = 209

        static let refreshPageButtonTop: CGFloat = 209
        static let refreshPageButtonHeight: CGFloat = 50
    }
    // MARK: - Private metohds
    private func setup() {
        stackView.addArrangedSubview(errorImageView)
        stackView.addArrangedSubview(errorTextLabel)
        stackView.addArrangedSubview(secondaryTextLabel)

        addSubview(stackView)
        addSubview(refreshPageButton)

        guard let superview = superview as? UIView, let stackView = stackView as? UIStackView else {
            return
        }

        let stackViewTopInset = Constants.stackViewTop
        let leadingInset = Constants.leading
        let trailingInset = Constants.trailing

        stackView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: stackViewTopInset)
        let leadingConstraint = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: leadingInset)
        let trailingConstraint = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: -trailingInset)
        
        superview.addConstraints([topConstraint, leadingConstraint, trailingConstraint])

        refreshPageButton.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: refreshPageButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)

        superview.addConstraints([topConstraint, leadingConstraint, trailingConstraint])
        refreshPageButton.addConstraint(heightConstraint)

    }
}
