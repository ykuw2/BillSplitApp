# Bill Split App

I wanted to create a simple app that solves a problem whenever my friends and I go out to eat - splitting the bill.
We always would have to pull out the calculator app and manually type in the numbers and do calculations that can be easily mixed up and leading to inaccurate splits.
I figured that since I learned more topics and structural pattern of how iOS apps should be created and organized, why not give it a shot to create an app that solves this issue.

## The App
### Welcome View
The app will first welcome you with a quick `WelcomeView` splash screen. It lasts only about 2 seconds, and will look like this:

<img width="300" height="650" alt="simulator_screenshot_4E4357EA-70EB-48F8-81E0-06A1A3BA9572" src="https://github.com/user-attachments/assets/d50a3a5f-03d0-4655-966a-8a5fcbb7b8fa" />

### Equal Split Section
This is the default screen (option) that the app takes you to.
The Equal Split Section is used for when you and your friends go to a restuarant and order in family style - everyone shares the dishes. This means that everyone's split is equal.

<img width="300" height="650" alt="simulator_screenshot_4790EFAA-982A-47F2-AF93-2188D615E3E6" src="https://github.com/user-attachments/assets/a81a8953-0a4a-4d31-8929-52469c935815" />

There are two tip types - `Percentage` and `Custom Amount`. `Percentage` like above - is calcuating the tip by percentage. The tax section will only pop up in this case, as tip is calcuated pre-tax.

`Custom Amount` is shown below, with an example usage!

<img width="300" height="650" alt="simulator_screenshot_1F013154-FD8A-4539-8F39-F3EBC7FDE8E5" src="https://github.com/user-attachments/assets/c4d1a820-f19d-4630-a9ec-c0e959f1a774" />

### Detailed Split Section
This is the other screen (option) that the app includes.

<img width="300" height="650" alt="simulator_screenshot_B3F53C38-B2AB-4D12-B8BE-B25D5D3C256A" src="https://github.com/user-attachments/assets/24e66bde-f558-4c90-b8fd-a47c0979974a" />

The Detailed Split Section is used for when everyone orders their own dishes and wants to figure out the split based on their portion (ratio) of the bill. You can add names, and then add the prices of the items below each names. 

You can delete the items or the person by swiping the item to the left and pressing "Delete". 

There are two tip types - `Percentage` and `Custom Amount`. `Percentage` like above - is calcuating the tip by percentage. 

We also include the `Miscellanous` section - this can be something like a "20% party over 6 gratuity" or "SF health tax". This is included when calculating tip - but we can easily adjust this in the future if wanted (In my use cases, we just include it in our tip calculation).

Here is an example usage below.

<img width="300" height="650" alt="simulator_screenshot_6C61C3B2-68C1-4630-AE71-7252E63E8533" src="https://github.com/user-attachments/assets/fc3cb36d-8ce2-47f6-b197-71b72144f2ba" />
<img width="300" height="650" alt="simulator_screenshot_1C1CE0EA-7EDA-4CF9-A9ED-6923108E692A" src="https://github.com/user-attachments/assets/a71d1996-e9f8-4544-91bb-b991f42eb528" />
