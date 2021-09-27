![Icon](../../img/icon.png)

# RVS_AutofillTextField_Test_Harness

## INTRODUCTION

This is the test harness app for [the RVS_AutofillTextField project](https://github.com/RiftValleySoftware/RVS_AutofillTextField/). It is a simple, standalone, iOS native Swift app, based on the [standard (classic) UIKit](https://developer.apple.com/documentation/uikit) model.

## REQUIREMENTS

There are no dependencies to use the widget, itself, but there are a couple that are required for this test harness:

1. [`RVS_Checkbox`](https://github.com/RiftValleySoftware/RVS_Checkbox)
2. [`RVS_GeneralObserver`](https://github.com/RiftValleySoftware/RVS_GeneralObserver)

The test harness builds [a dynamic framework](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/OverviewOfDynamicLibraries.html) of the widget, and imports it, in order to provide a relevant usage example, similar to use of the widget via [the Swift Package Manager](https://swift.org/package-manager/).

## USAGE


## LICENSE

MIT License

Copyright (c) 2021 Rift Valley Software, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
