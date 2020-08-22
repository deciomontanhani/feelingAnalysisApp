import UIKit

final class TweetsListView: UIView {

    weak var delegate: TweetsListViewDelegate?

    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.delegate = self
        view.autocapitalizationType = .none
        view.placeholder = "Digite um usuário do Twitter aqui"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var loadingErrorView: LoadingErrorView = {
        let view = LoadingErrorView()
        view.delegate = self
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetCell.self, forCellReuseIdentifier: TweetCell.className)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    init() {
        super.init(frame: .zero)
        buildViewCode()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

}

extension TweetsListView: ViewCode {
    func buildHierarchy() {
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(loadingErrorView)
    }

    func buildConstraints() {
        searchBar.top(to: self, self.safeAreaLayoutGuide.topAnchor)
        searchBar.left(to: self)
        searchBar.right(to: self)

        loadingErrorView.topToBottom(of: searchBar)
        loadingErrorView.left(to: self)
        loadingErrorView.right(to: self)
        loadingErrorView.bottom(to: self)

        tableView.topToBottom(of: searchBar)
        tableView.left(to: self)
        tableView.right(to: self)
        tableView.bottom(to: self)

    }

    func additionalSetup() {
        loadingErrorView.set(state: .error)
        backgroundColor = .white
    }
}

extension TweetsListView: TweetsListViewProtocol {
    func reloadTable() {
        tableView.reloadData()
    }

    func showLoading() {
        loadingErrorView.set(state: .loading)
    }

    func stopLoading() {
        loadingErrorView.set(state: .hidden)
    }

    func showError(message: String?) {
        loadingErrorView.set(text: message)
        loadingErrorView.set(state: .error)
    }
}

extension TweetsListView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchProfile(searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}

extension TweetsListView: LoadingErrorViewProtocol {
    func retry() {
        delegate?.retrySearch()
    }
}

extension TweetsListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didTapTweet(at: indexPath.row)
    }
}

extension TweetsListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.getTweetsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = delegate else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(with: TweetCell.self, for: indexPath)

        let model = delegate.getTweetModel(at: indexPath.row)
        let user = delegate.getCurrentUser()
        cell.setup(username: user, tweet: model?.text)
        return cell
    }
}
