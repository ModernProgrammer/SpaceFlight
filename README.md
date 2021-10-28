# README

## Table of contents
* [General info](#general-info)
* [Unit Testing](#unit-testing)
* [Technologies](#technologies)
* [Setup](#setup)

## General info
SpaceFlight is a simple app built using the MVVM design pattern which reads from
the [SpaceFlight API](https://api.spaceflightnewsapi.net/v3/documentation).
SpaceFlight supports both Dark Mode and Light Mode based on the system settings
with the theme accent color of the app being systemRed. The UI was built primarily
using UIKit while some cells were built using SwiftUI. All of the network requests
used URLSession to reduce the dependency of using Cocoapods or any other framework. I
created a custom `UIImageView` class called `CustomImageView` which handles the
`UIActivityIndicatorView` and caches images.

## Generated Code
In the first revision of SpaceFlight, I used PostMan to test the API get requests for
the `fetchArticles` function in the `SpaceFlightModelView`. I integrated the
generated code from PostMan but have since then completely rewritten the function to
better handle returned errors, invalid responses, and invalid data. 

Another part of the generated code I rewritten was the model for `Articles`. I used
[quicktype.io](https://quicktype.io) to convert JSON objects into Swift Models to
allow for the model to be used as a `Codable` object. It tends to work well but
usually returns a model object that has too many properties that are not needed. I
have rewritten the model to store the properties of the API that are being used. This
helped clean up the code significantly and reduced the property size of the `Article`
model.
 
## Unit Testing
Although I am very new to Unit testing, I watched a [WWDC video](https://developer.apple.com/videos/play/wwdc2017/414/) and did my best to
integrate a MockClass that will return expected data. Which would allow for testing
in the Unit Test much cleaner. I created two Mock classes using protocols. One that
tests the `SpaceFlight API` and the other tests the `CustomImageView` class.
    
## Technologies
Project is created with:
* UIKit
* SwiftUI
* URLSession for network requests
* Space Flight API

## Setup
This project contains no dependencys. Works right out of the box.


