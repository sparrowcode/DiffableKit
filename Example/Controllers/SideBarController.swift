import UIKit

@available(iOS 14, *)
class SidebarController: SPDiffableSideBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellProviders([CellProvider.itemCellProvider, CellProvider.headerCellProvider], sections: content)
    }
    
    enum Section: String {
        
        case tabs = "tabs"
        case library = "library"
        case playlists = "playlists"
    }
    
    var content: [SPDiffableSection] {
        var content: [SPDiffableSection] = []
        content.append(
            SPDiffableSection(
                identifier: Section.tabs.rawValue,
                items: [
                    SPDiffableSideBarMenuItem(title: "Listen Now", image: UIImage(systemName: "play.circle"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Browse", image: UIImage(systemName: "square.grid.2x2"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Radio", image: UIImage(systemName: "dot.radiowaves.left.and.right"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), action: { _ in })
                ])
        )
        content.append(
            SPDiffableSection(
                identifier: Section.library.rawValue,
                header: SPDiffableSideBarHeader(text: "Library", accessories: [.outlineDisclosure()]),
                items: [
                    SPDiffableSideBarMenuItem(title: "Recently Added", image: UIImage(systemName: "clock"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Artists", image: UIImage(systemName: "music.mic"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Albums", image: UIImage(systemName: "rectangle.stack"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Songs", image: UIImage(systemName: "music.note"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Music Videos", image: UIImage(systemName: "tv.music.note"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "TV & Movies", image: UIImage(systemName: "tv"), action: { _ in })
                ])
        )
        content.append(
            SPDiffableSection(
                identifier: Section.playlists.rawValue,
                header: SPDiffableSideBarHeader(text: "Playlists", accessories: [.outlineDisclosure()]),
                items: [
                    SPDiffableSideBarMenuItem(title: "All Playlists", image: UIImage(systemName: "music.note.list"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Replay 2015", image: UIImage(systemName: "music.note.list"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Replay 2016", image: UIImage(systemName: "music.note.list"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Replay 2017", image: UIImage(systemName: "music.note.list"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Replay 2018", image: UIImage(systemName: "music.note.list"), action: { _ in }),
                    SPDiffableSideBarMenuItem(title: "Replay 2019", image: UIImage(systemName: "music.note.list"), action: { _ in })
                ])
        )
        return content
    }
}

@available(iOS 14, *)
class SideBarSplitController: UISplitViewController {
    
    init() {
        super.init(style: .doubleColumn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
        preferredSplitBehavior = .tile
        
        let sideBarController = SidebarController()
        sideBarController.navigationItem.title = "Side Bar"
        sideBarController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .close, target: nil, action: #selector(self.dismissAnimated))
        let primaryController = UINavigationController(rootViewController: sideBarController)
        primaryController.navigationBar.prefersLargeTitles = true
        setViewController(primaryController, for: .primary)
        
        let controller = UIViewController()
        controller.view.backgroundColor = .systemBackground
        controller.navigationItem.title = "Secondary"
        let secondaryController = UINavigationController(rootViewController: controller)
        secondaryController.navigationBar.prefersLargeTitles = true
        setViewController(secondaryController, for: .secondary)
    }
    
    @objc func dismissAnimated() {
        self.dismiss(animated: true, completion: nil)
    }
}

