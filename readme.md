# Appointments

A small app, attempting to fulfill requirements based on the (Figma Specs)[https://www.figma.com/file/jcBIaI0nXVD9McL3jALsSg/Conversation-iOS-Take-Home-(iOS-Engineer)?node-id=0%3A1&t=53HeveXxDR1v8rtG-0]

## Requirements

* iOS 15.6+

* Xcode 14.2+

## Notes

* This shows how composable features would work, ideally the two features would be pulled into Swift Package Manager modules to further allow modularization

* We're using the native NavigationView stack instead of a custom navigation header, mainly out of time pressure

* Some of the extensions that are added to the Appointment model as well as the status model could be optimized and potentially moved into the view state

* The logic of time display isn't clear and documented in the specs, I've added some assumptions around it and documented those, but they might be flawed

* Tapping `Join Appointment` doesn't do anything

* Design guidelines have been followed as good as possible given the restricted amount of time. 
