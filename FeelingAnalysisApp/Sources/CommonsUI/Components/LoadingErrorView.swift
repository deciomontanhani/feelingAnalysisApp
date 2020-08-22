//
//  LoadingErrorView.swift
//  FeelingAnalysisApp
//
//  Created by Decio Montanhani on 20/08/20.
//  Copyright © 2020 Decio Montanhani. All rights reserved.
//

import UIKit

protocol LoadingErrorViewProtocol: AnyObject {
    func retry()
}

enum LoadingErrorViewState {
    case loading, error, hidden
}

final class LoadingErrorView: UIView {

    weak var delegate: LoadingErrorViewProtocol?

    private var text: String? {
        didSet {
            title.text = text
        }
    }

    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.text = "Não foi possível realizar a busca"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tryButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Tentar novamente", for: .normal)
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        return button
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, tryButton, spinner])
        stack.alignment = .center
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init() {
        super.init(frame: .zero)
        buildViewCode()
        loading()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    func set(state: LoadingErrorViewState) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                self.loading()
            case .error:
                self.error()
            case .hidden:
                self.hidden()
            }
        }
    }

    func set(text: String? = "Não foi possível realizar a busca") {
        self.text = text
    }
}

private extension LoadingErrorView {
    @objc
    func didTapRetry() {
        delegate?.retry()
    }

    func loading() {
        title.isHidden = true
        tryButton.isHidden = true
        spinner.isHidden = false
        isHidden = false
    }
    func error() {
        title.isHidden = false
        tryButton.isHidden = false
        spinner.isHidden = true
        isHidden = false
    }
    func hidden() {
        isHidden = true
    }
}

extension LoadingErrorView: ViewCode {
    func buildHierarchy() {
        addSubview(contentStack)
    }

    func buildConstraints() {
        contentStack.center(in: self)
        contentStack.left(to: self, offset: 24)
        contentStack.right(to: self, offset: 24)
    }

    func additionalSetup() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
}
