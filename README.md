# LineChartView

`LineChartView` is a Swift Package written in SwiftUI to add a line chart to your app. It has many available customizations and is interactive (user can move finger on line to get values details).

It is really easy to use and add to your app. It only takes an array of `Double` values as mandatory parameter. All other parameters are here to customize visual aspect and interactions.

## Features

- Displays `Double` values in a line chart
- Add labels to each value (as `String`)
- Change label (value) and secondary label colors
- Change labels alignment (left, center, right)
- Change indicator point color and size
- Change line color (simple color or linear gradient with two colors)
- Display dots for each point/value on line
- Enable/disable drag gesture
- Enable/disable haptic feedback when drag on exact value
- Use SwiftUI modifiers to custom chart (like background or frame size)

## Usage

First create a `LineChartParameters` and set parameters to customize your brand you chart. Only first `data` parameter is mandatory to provide your values (as an array of `Double`).

Then create a `LineChartView` by passing your `LineChartParameter`.

## I'm working on...

🚧 Developer at work 🚧

- Animation when line is drawn


## Licence

Be free to use my `LineChartView` Package in your app. Licence is available [here](https://github.com/Jonathan-Gander/LineChartView/blob/main/LICENSE). Please only add a copyright and licence notice.

Note that I've based my solution on [stock-charts](https://github.com/denniscm190/stock-charts). I've totally modified and changed it but you may found similar code parts.
