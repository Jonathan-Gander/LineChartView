# LineChartView

`LineChartView` is a Swift Package written in SwiftUI to add a line chart to your app. It has many available customizations and is interactive (user can move finger on line to get values details).

It is really easy to use and to add to your app. It only takes an array of `Double` values as mandatory parameter. All other parameters are here to customize visual aspect and interactions.

## 🆕 Prefix and suffix to values
You can now add a prefix and/or a suffix to add to your values when displayed. For example, if your values are kilograms, you can add a suffix ` kg` to display `42 kg` instead of only `42`.

## Features

- Displays `Double` values in a line chart
- Support value serie (by default) or time serie
- Add labels to each value (as `String`)
- Add prefix and/or suffix to displayed data (as "42 kg" for example)
- Change label (value) and secondary label colors
- Change labels alignment (left, center, right)
- Change number of digits after decimal point
- Change indicator point color and size
- Change line color (simple color or linear gradient with two colors)
- Display dots for each point/value on line
- Enable/disable drag gesture
- Enable/disable haptic feedback when drag on exact value
- Use SwiftUI modifiers to customize chart (like background or frame size)

## Value serie or time serie as x axis
By default, all values are displayed on x axis with equal distance between them (value serie). But you can also provide a timestamp (`Date` object) for each value. In this case, values are displayed on x axis depending on timestamp. For example, if you have 3 values with timestamps 03:00, 03:30 and 08:00, space between first and second one will be smaller than space between second and third one. It lets you display a line chart as time serie instead of just a value serie.

To set your chart as a time serie, simply set `dataTimestamps` parameter with an array of `Date` (one for each point).

## Examples

### Default basic version (without any customization):

![Basic light](https://user-images.githubusercontent.com/1695222/143007122-fda76cd6-db04-41a8-bde3-d4cc6a28ea36.png)

![Basic dark](https://user-images.githubusercontent.com/1695222/143007298-c454db5b-b636-4e68-91e5-c1eeff4a8749.png)

### Examples with customizations:

![Custom 1](https://user-images.githubusercontent.com/1695222/143007907-7acd8f2e-3e04-452f-9a04-67fdceeb80af.png)

![Custom 2](https://user-images.githubusercontent.com/1695222/143008445-e532c171-a659-42b9-b2c6-49c5bacda214.png)

![Custom 3](https://user-images.githubusercontent.com/1695222/143009005-f1def92c-4679-4fca-a6dc-5fab3c161eb9.png)

![CHF](https://user-images.githubusercontent.com/1695222/161321934-2560c670-5a6d-46ca-8494-429943d18684.png)

![Custom 4](https://user-images.githubusercontent.com/1695222/143009330-71530e2b-a7d0-4766-9b19-2fb000147486.png)

![Custom 5](https://user-images.githubusercontent.com/1695222/143010489-88d4d4b0-1ab8-4b77-adf0-337513be3426.png)


## Usage

### Installation

Add `LineChartView` package to your project. 

In Xcode 13.1: `File` -> `Add Packages...` then enter my project GitHub URL:  
`https://github.com/Jonathan-Gander/LineChartView`

### Quick start
In file you want to add a chart:

```swift
import LineChartView
```

First create a `LineChartParameters` and set parameters to customize your chart. Only first `data` parameter is mandatory to provide your values (as an array of `Double`):

```swift
let chartParameters = LineChartParameters(data: [42.0, 25.8, 88.19, 15.0])
```

Then create a `LineChartView` by passing your `LineChartParameter`:

```swift
LineChartView(lineChartParameters: chartParameters)
```

### Complete examples

Here is an example of a `View` displaying a chart with values and labels, and set its height:

```swift
import SwiftUI
import LineChartView

struct ContentView: View {
    
    private let data: [Double] = [42.0, 25.8, 88.19, 15.0]
    private let labels: [String] = ["The answer", "Any text here", "2021-11-21", "My number"]
    
    var body: some View {
        let chartParameters = LineChartParameters(data: data, dataLabels: labels)
        LineChartView(lineChartParameters: chartParameters)
            .frame(height: 300)
    }
}
```

Same example, but with timestamps so x axis is a time serie:

```swift
import SwiftUI
import LineChartView

struct ContentView: View {
    private let data: [Double] = [42.0, 25.8, 88.19, 15.0]
    private var timestamps: [Date] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        var dates = [Date]()
        dates.append(formatter.date(from: "2021/12/10 10:00")!)
        dates.append(formatter.date(from: "2021/12/10 10:05")!)
        dates.append(formatter.date(from: "2021/12/10 10:18")!)
        dates.append(formatter.date(from: "2021/12/10 11:01")!)
        return dates
    }
    
    var body: some View {
        let chartParameters = LineChartParameters(data: data,
                                                  dataTimestamps: timestamps,
                                                  dataLabels: timestamps.map({ $0.formatted(date: .numeric, time: .standard) }))
        LineChartView(lineChartParameters: chartParameters)
            .frame(height: 300)
    }
}
```

## Customize your chart

To customize your chart, you can set parameters of `LineChartParameters`. Here are explanations of each parameter:

- `data`: (mandatory) Array of `Double` containing values to display
- `dataTimestamps`: Array of `Date` containing timestamp for each value (time serie). This array must have same number of items than `data` array. Set to nil to display default value serie.
- `dataLabels`: Array of `String` containing label for each value
- `labelColor`: Color of values text
- `secondaryLabelColor`: Color of labels text
- `labelsAlignment`: `.left`, `.center`, `.right` to align both labels above chart
- `dataPrecisionLength`: Number of digits after the decimal point (round value). Default to `2`. Warning: Only available on iOS 15+.
- `dataPrefix`: Text displayed before data value (for example: "$" to display "$42")
- `dataSuffix`: Text displayed after data value (for example: " kg" to display "42 kg")
- `indicatorPointColor`: Color of indicator point displayed when user drags finger on chart
- `indicatorPointSize`: Size of indicator point
- `lineColor`: First color of line
- `lineSecondColor`: If set, will display a linear gradient from left to right from `lineColor` to `lineSecondColor`
- `lineWidth`: Line width
- `dotsWidth`: Display a dot for each value (set to `-1` to hide dots)
- `dragGesture`: Enable or disable drag gesture on chart
- `hapticFeedback`: Enable or disable haptic feedback on each value point

Example of a complete `LineChartParameters`:

```swift
let chartParameters = LineChartParameters(
    data: data,
    dataTimestamps: timestamps,
    dataLabels: labels,
    labelColor: .primary,
    secondaryLabelColor: .secondary,
    labelsAlignment: .left,
    dataPrecisionLength: 0,
    dataPrefix: nil,
    dataSuffix: " kg",
    indicatorPointColor: .blue,
    indicatorPointSize: 20,
    lineColor: .blue,
    lineSecondColor: .purple,
    lineWidth: 3,
    dotsWidth: 8,
    dragGesture: true,
    hapticFeedback: true
)
```

## I'm working on...

🚧 Developer at work 🚧

- Animation when line is drawn ([issue #2](https://github.com/Jonathan-Gander/LineChartView/issues/2))

## They're already using it

If you use my `LineChartView` in your app, please let me know and I will add your link here. You can [contact me here](https://contact.gander.family?locale=en).

## Licence

Be free to use my `LineChartView` Package in your app. Licence is available [here](https://github.com/Jonathan-Gander/LineChartView/blob/main/LICENSE). Please only add a copyright and licence notice.

Note that I've based my solution on [stock-charts](https://github.com/denniscm190/stock-charts). I've totally modified and changed it but you may found similar code parts.
