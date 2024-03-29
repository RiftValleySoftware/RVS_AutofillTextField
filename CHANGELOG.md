# RVS_AutofillTextField Change Log

## 1.3.6

- **January 6, 2024**

- Updated to use the new "UISwitch" checkbox class.
- Updated to latest tools.
- Added privacy declarations.

## 1.3.5

- **January 8, 2023**

- I need to also put away the keyboard.

## 1.3.4

- **January 7, 2023**

- Oops. Recursabug (bug within bug). I was looking for false, when I should have been looking for true.

## 1.3.3

- **January 7, 2023**

- Fixed a bug, where the open menu could be left displayed, when the control is hidden.

## 1.3.2

- **October 6, 2022**

- Updated a test harness dependency. No API changes.

## 1.3.1

- **September 16, 2022**

- Updated to latest tools and dependencies. No API changes.

## 1.3.0

- **May 31, 2022**

- Removed the dash-notation.
- Updated to latest tools. No API changes.

## 1.2.11

- **March 15, 2022**

- Updated to the latest tools. No other changes.

## 1.2.10

- **January 27, 2022**

- Added DocC support (no change to the code or API, other than a version bump).

## 1.2.9

- **December 14, 2021**

- Updated to the latest tools.

## 1.2.8

- **October 24, 2021**

- Added an #if clause to prevent IB errors.

## 1.2.7

- **October 3, 2021**

- I re-added the `UILabel.showsExpansionTextWhenTruncated` property, as it's just too damn useful. I had to wrap it in an availablility test, though.
- Some basic work to make it a bit more performant.
- Added the `refreshTable()` method.

## 1.2.6

- **October 2, 2021**

- Found an issue that caused crashes on iOS14 devices. I was referencing the `UILabel.showsExpansionTextWhenTruncated` property, and this was allowed to compile for 14, but wasn't actually there.

## 1.2.5

- **October 2, 2021**

- Tweaked a few more things, to try to add as much "robustness" to the widget as possible. Doubtful these changes will make a difference, but belt & suspenders...

## 1.2.4

- **October 2, 2021**

- Experienced some strange crashes, with an implementation, when running under stress. Added [weak self] in several places, just in case...

## 1.2.3

- **September 29, 2021**

- I now take the keyboard height into account. This is especially important for -1 maximum count.
- All the inspectables now trigger layout.
- The keyboard type for the test harness maximum count was the wrong type. It would not allow -1.

## 1.2.2

- **September 29, 2021**

- Code smell cleanup.
- Documentation cleanup.
- Addressed a possible crasher, if the text is wiped out while the table is being dismantled.

## 1.2.1

- **September 28, 2021**

- Fixed a bug in the delegate call. It was possible to have a crash, if selecting the last item.
- FAUGH! Code smell bad! Me spritz stink-pretty. Mmmm...Code smell good!

## 1.2.0

- **September 28, 2021**

- Added a delegate protocol, allowing notification of user selection.
- The dropdown now attaches to the window object. This allows it to float over popovers.

## 1.1.0

- **September 27, 2021**

- Added the ability to explicitly assign a container view for the popover. If that view is not provided, then the main window root view is used.

## 1.0.2

- **September 27, 2021**

- Mostly documentation improvements.
- The control will redraw the table background, every time it refreshes, as opposed to just when it is created. This allows "on the fly" color changes.
- The control will now refresh when a few of the properties are changed.

## 1.0.1

- **September 26, 2021**

- Minor efficiency and documentation improvements.

## 1.0.0

- **September 26, 2021**

- Initial release
