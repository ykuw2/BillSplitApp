# Bill Split App

I wanted to create a simple app that solves a problem whenever my friends and I go out to eat - splitting the bill.
We always would have to pull out the calculator app and manually type in the numbers and do calculations that can be easily mixed up and leading to inaccurate splits.
I figured that since I learned more topics and structural pattern of how iOS apps should be created and organized, why not give it a shot to create an app that solves this issue.

This will be my first iOS App that I create. I know this app will not be the best, but it is a start of a journey.

## The App

### The App Icon
Below is the app icon used:

<img width="100" height="100" alt="bill_split" src="https://github.com/user-attachments/assets/cc73cfb2-23c9-45a2-a74c-f0c89197e4d3" />

### Welcome View
The app will first welcome you with a quick `WelcomeView` splash screen. It lasts only about 2 seconds, and will look like this:

<img width="300" height="650" alt="simulator_screenshot_FA7F3D1F-7FA7-4322-99C4-12A41821C91D" src="https://github.com/user-attachments/assets/6464f707-cd0e-43cc-ba15-060a4664a2cd" />

### Equal Split Section
This is the default screen (option) that the app takes you to.
The Equal Split Section is used for when you and your friends go to a restuarant and order in family style - everyone shares the dishes. This means that everyone's split is equal.

<img width="300" height="650" alt="simulator_screenshot_27BD0207-5C6E-48DE-B0DC-CCAFF41A3CCC" src="https://github.com/user-attachments/assets/2d0cd5a6-8166-48b9-91cd-21d447835afd" />

There are two tip types - `Percentage` and `Custom Amount`. `Percentage` like above - is calcuating the tip by percentage. The tax section will only pop up in this case, as tip is calcuated pre-tax.

`Custom Amount` is shown below, with an example usage!

<img width="300" height="650" alt="simulator_screenshot_68F3701A-58AA-4423-B8EA-597CDB4B6484" src="https://github.com/user-attachments/assets/3bbc55b1-189e-47d4-b2aa-4d20e5c19341" /> 

### Detailed Split Section
This is the other screen (option) that the app includes.

<img width="300" height="650" alt="simulator_screenshot_8C9EF401-EA9C-45E5-B888-2E4EAA65464F" src="https://github.com/user-attachments/assets/4278e85e-32cc-444a-bfaf-d5615f76615b" />

The Detailed Split Section is used for when everyone orders their own dishes and wants to figure out the split based on their portion (ratio) of the bill. You can add names, and then add the prices of the items below each names. 

You can delete the items or the person by swiping the item to the left and pressing "Delete". 

There are two tip types - `Percentage` and `Custom Amount`. `Percentage` like above - is calcuating the tip by percentage. 

We also include the `Miscellanous` section - this can be something like a "20% party over 6 gratuity" or "SF health tax". This is included when calculating tip - but we can easily adjust this in the future if wanted (In my use cases, we just include it in our tip calculation).

Here is an example usage below.

<img width="300" height="650" alt="simulator_screenshot_0706C180-A174-43E2-91C8-469D41404BB6" src="https://github.com/user-attachments/assets/7450fb1b-4a95-42b2-bf46-35bc5e5af33f" />
<img width="300" height="650" alt="simulator_screenshot_EE482863-9817-4E55-AC8D-277976A379A5" src="https://github.com/user-attachments/assets/199dc5f4-3cc8-4541-9555-89c8baf1a80f" />
