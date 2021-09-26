![Icon](img/icon.png)

# RVS_AutofillTextField

## INTRODUCTION

This is a standard [`UITextField`](https://developer.apple.com/documentation/uikit/uitextfield), extended to provide an "autofill" dropdown menu, under the widget. This widget will provide matches, within an Array of Strings, which can be used as "autofill." If one of the strings is selected by the user, then it is entered, in its entirety, into the text field.

![Example Display](img/Figure-01.png)

This is, by default, a simple, "one-way," "greedy" match. It starts from the beginning, then moves forward, matching the characters entered into the text field. They must all match, but the match can be case/diacritical-independednt (by default).

We can choose several modes of matching, so we can "wildcard" text before and/or after the string (or insist on an exact match).

## WHAT PROBLEM DOES THIS SOLVE?

Entering text on phones isn't easy. This helps to reduce the amount of text we actually need to enter.

Additionally, this can help us to "explore" datasets, by entering partial specifications. For example, if we are searching for users in a certain area, we might do a "triage" search, and create a subset of the main database of users, for the locality. These can be used as autofill suggestions, when looking for a user.
