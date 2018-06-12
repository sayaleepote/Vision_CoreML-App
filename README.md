# Vision_CoreML-App
This app predicts the age of a person from the picture input using camera or photos gallery. <br>
For this, the app uses <a href="https://developer.apple.com/documentation/coreml">Core ML</a> framework of iOS. The <a href="https://developer.apple.com/documentation/vision">Vision </a> library of CoreML is also used here as the trained model takes image input.<br><br>
The trained model fed to the system is <a href="https://coreml.store/agenet">AgeNet</a>, which is a Age Classification model using Convolutional Neural Networks. This model takes a 277x277 image as input and predicts the age of the person and outputs the same. <br>

<br>

Here is how the application would look like: <br>
![Demo](https://user-images.githubusercontent.com/14230368/41271531-cc1c3510-6e2e-11e8-87ce-56d3ed322b67.gif)

<br><br>
System Requirements: <br>
1. MacOS (Sierra 10.12 or above) <br>
2. Xcode 9 or above <br>
3. Device with iOS 11 or above. Good news - The app can run on a simulator as well! <br>
