// The MIT License (MIT)
// Copyright © 2020 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

@available(iOS 14, *)
class SidebarController: SPDiffableSideBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellProviders([SPDiffableCollectionCellProviders.sideBar], sections: content)
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
                    SPDiffableSideBarItem(title: "Listen Now", image: UIImage(systemName: "play.circle"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Browse", image: UIImage(systemName: "square.grid.2x2"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Radio", image: UIImage(systemName: "dot.radiowaves.left.and.right"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), action: { _ in }),
                    SPDiffableSideBarButton(title: "Button", image: UIImage(systemName: "plus.square.fill"), action: { [weak self] _ in
                        guard let self = self else { return }
                        let controller = UIViewController()
                        controller.view.backgroundColor = .systemBackground
                        self.present(controller, animated: true, completion: nil)
                    })
                ])
        )
        content.append(
            SPDiffableSection(
                identifier: Section.library.rawValue,
                header: SPDiffableSideBarHeader(text: "Library", accessories: [.outlineDisclosure()]),
                items: [
                    SPDiffableSideBarItem(title: "Recently Added", image: UIImage(systemName: "clock"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Artists", image: UIImage(systemName: "music.mic"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Albums", image: UIImage(systemName: "rectangle.stack"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Songs", image: UIImage(systemName: "music.note"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Music Videos", image: UIImage(systemName: "tv.music.note"), action: { _ in }),
                    SPDiffableSideBarItem(title: "TV & Movies", image: UIImage(systemName: "tv"), action: { _ in })
                ])
        )
        content.append(
            SPDiffableSection(
                identifier: Section.playlists.rawValue,
                header: SPDiffableSideBarHeader(text: "Playlists", accessories: [.outlineDisclosure()]),
                items: [
                    SPDiffableSideBarItem(title: "All Playlists", image: UIImage(systemName: "music.note.list"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Replay 2015", image: UIImage(systemName: "music.note.list"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Replay 2016", image: UIImage(systemName: "music.note.list"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Replay 2017", image: UIImage(systemName: "music.note.list"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Replay 2018", image: UIImage(systemName: "music.note.list"), action: { _ in }),
                    SPDiffableSideBarItem(title: "Replay 2019", image: UIImage(systemName: "music.note.list"), action: { _ in })
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
        
        primaryBackgroundStyle = .sidebar
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

