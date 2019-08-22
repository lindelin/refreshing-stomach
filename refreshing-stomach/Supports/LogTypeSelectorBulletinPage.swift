/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BLTNBoard

/**
 * An item that displays a choice with two buttons.
 *
 * This item demonstrates how to create a page bulletin item with a custom interface, and changing the
 * next item based on user interaction.
 */

class LogTypeSelectorBulletinPage: FeedbackPageBLTNItem {

    private var homeButtonContainer: UIButton!
    private var officeButtonContainer: UIButton!
    private var othersButtonContainer: UIButton!
    private var selectionFeedbackGenerator = SelectionFeedbackGenerator()
    
    var selectedLogType: LogType = .home

    // MARK: - BLTNItem

    /**
     * Called by the manager when the item is about to be removed from the bulletin.
     *
     * Use this function as an opportunity to do any clean up or remove tap gesture recognizers /
     * button targets from your views to avoid retain cycles.
     */

    override func tearDown() {
        homeButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
        officeButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
        othersButtonContainer?.removeTarget(self, action: nil, for: .touchUpInside)
    }

    /**
     * Called by the manager to build the view hierachy of the bulletin.
     *
     * We need to return the view in the order we want them displayed. You should use a
     * `BulletinInterfaceFactory` to generate standard views, such as title labels and buttons.
     */

    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        
        // Types Stack

        // We add choice cells to a group stack because they need less spacing
        let typesStack = interfaceBuilder.makeGroupStack(spacing: 16)

        // Home Button
        let homeButtonContainer = createChoiceCell(dataSource: .home, isSelected: selectedLogType == .home)
        homeButtonContainer.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        typesStack.addArrangedSubview(homeButtonContainer)

        self.homeButtonContainer = homeButtonContainer

        // Office Button
        let officeButtonContainer = createChoiceCell(dataSource: .office, isSelected: selectedLogType == .office)
        officeButtonContainer.addTarget(self, action: #selector(officeButtonTapped), for: .touchUpInside)
        typesStack.addArrangedSubview(officeButtonContainer)

        self.officeButtonContainer = officeButtonContainer
        
        // Others Button
        let othersButtonContainer = createChoiceCell(dataSource: .others, isSelected: selectedLogType == .others)
        othersButtonContainer.addTarget(self, action: #selector(othersButtonTapped), for: .touchUpInside)
        typesStack.addArrangedSubview(othersButtonContainer)
        
        self.othersButtonContainer = othersButtonContainer

        return [typesStack]
    }

    // MARK: - Custom Views

    /**
     * Creates a custom choice cell.
     */

    func createChoiceCell(dataSource: LogType, isSelected: Bool) -> UIButton {

        let emoji: String
        let animalType: String

        switch dataSource {
        case .home:
            emoji = "🏠"
        case .office:
            emoji = "🏢"
        case .others:
            emoji = "❓"
        }
        
        animalType = dataSource.name()

        let button = UIButton(type: .system)
        button.setTitle(emoji + " " + animalType, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.contentHorizontalAlignment = .center
        button.accessibilityLabel = animalType

        if isSelected {
            button.accessibilityTraits.insert(.selected)
        } else {
            button.accessibilityTraits.remove(.selected)
        }

        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2

        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 55)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true

        let buttonColor = isSelected ? appearance.actionButtonColor : .lightGray
        button.layer.borderColor = buttonColor.cgColor
        button.setTitleColor(buttonColor, for: .normal)
        button.layer.borderColor = buttonColor.cgColor

        return button
    }

    // MARK: - Touch Events

    @objc func homeButtonTapped() {

        // Play haptic feedback
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Update UI
        let homeButtonColor = appearance.actionButtonColor
        homeButtonContainer?.layer.borderColor = homeButtonColor.cgColor
        homeButtonContainer?.setTitleColor(homeButtonColor, for: .normal)
        homeButtonContainer?.accessibilityTraits.insert(.selected)

        let inactiveColor = UIColor.lightGray
        officeButtonContainer?.layer.borderColor = inactiveColor.cgColor
        officeButtonContainer?.setTitleColor(inactiveColor, for: .normal)
        officeButtonContainer?.accessibilityTraits.remove(.selected)
        
        othersButtonContainer?.layer.borderColor = inactiveColor.cgColor
        othersButtonContainer?.setTitleColor(inactiveColor, for: .normal)
        othersButtonContainer?.accessibilityTraits.remove(.selected)
        
        selectedLogType = .home
    }

    @objc func officeButtonTapped() {

        // Play haptic feedback
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Update UI
        let officeButtonColor = appearance.actionButtonColor
        officeButtonContainer?.layer.borderColor = officeButtonColor.cgColor
        officeButtonContainer?.setTitleColor(officeButtonColor, for: .normal)
        officeButtonContainer?.accessibilityTraits.insert(.selected)

        let inactiveColor = UIColor.lightGray
        homeButtonContainer?.layer.borderColor = inactiveColor.cgColor
        homeButtonContainer?.setTitleColor(inactiveColor, for: .normal)
        homeButtonContainer?.accessibilityTraits.remove(.selected)
        
        othersButtonContainer?.layer.borderColor = inactiveColor.cgColor
        othersButtonContainer?.setTitleColor(inactiveColor, for: .normal)
        othersButtonContainer?.accessibilityTraits.remove(.selected)
        
        selectedLogType = .office
    }
    
    @objc func othersButtonTapped() {
        
        // Play haptic feedback
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()
        
        // Update UI
        let othersButtonColor = appearance.actionButtonColor
        othersButtonContainer?.layer.borderColor = othersButtonColor.cgColor
        othersButtonContainer?.setTitleColor(othersButtonColor, for: .normal)
        othersButtonContainer?.accessibilityTraits.insert(.selected)
        
        let inactiveColor = UIColor.lightGray
        homeButtonContainer?.layer.borderColor = inactiveColor.cgColor
        homeButtonContainer?.setTitleColor(inactiveColor, for: .normal)
        homeButtonContainer?.accessibilityTraits.remove(.selected)
        
        officeButtonContainer?.layer.borderColor = inactiveColor.cgColor
        officeButtonContainer?.setTitleColor(inactiveColor, for: .normal)
        officeButtonContainer?.accessibilityTraits.remove(.selected)
        
        selectedLogType = .others
    }
    
    func createLog(type: LogType) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let log = Log(context: appDelegate.persistentContainer.viewContext)
        log.id = UUID()
        log.type = type.rawValue
        log.createdAt = Date()
        appDelegate.saveContext()
    }

    override func actionButtonTapped(sender: UIButton) {

        // Play haptic feedback
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        createLog(type: selectedLogType)
        
        manager?.dismissBulletin()
    }

}
