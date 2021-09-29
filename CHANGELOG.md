# RVS_AutofillTextField Change Log

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
