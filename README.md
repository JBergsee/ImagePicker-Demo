# ImagePicker-Demo
Showing a bug in iOS, which freezes the interface when the UISlider appearance is modified in a certain way before presenting the UIImagePickerController in camera mode.

## Conditions
The issue only occurs on some devices. If the camera view shows a UISlider for the zoom level, the issue will occur. However, the camera view on other devices shows a circle with the zoom level in text. The issue does not occur when this is the case.
Changing both sliderAppearance.minimumTrackTintColor and sliderAppearance.maximumTrackTintColor is required for the issue to occur. Changing only one is not enough.
