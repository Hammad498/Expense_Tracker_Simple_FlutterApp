# expense_tracker_flutter app

1. 2 screens
2. home and add_expenses screen
  
Builds the main content of the Home Screen
Income input field with validation
Button to navigate to Expense Screen with animation
code :  build, _buildHomeBody, _buildIncomeInput, _buildNavigateButton

Expense Screen: 
•	AppBar: "Expenses for Hammad".
•	Text: Displays non-editable income.
•	Text/TextField: Seven categories with number inputs.
•	ElevatedButton: Calculates expenses and shows result.

1. Layout Widgets: 
I used Column to vertically arrange elements like the welcome text, input, and button on the Home Screen, ensuring a clean, centered layout. Row aligns category labels and text fields horizontally on the Expense Screen for balanced spacing. Card adds visual depth with elevation, SingleChildScrollView ensures scrollability, and SafeArea avoids screen notches.

2.Value Widgets and Dynamic Data: 
Text displays static (e.g., "Welcome, Hammad") and dynamic data (e.g., income, result message) using widget.income and _message. TextField captures user input with TextEditingController, updating dynamically with error text for invalid inputs. ElevatedButton triggers navigation or calculations, showing feedback via SnackBar or result messages.

3.Flutter UI Rebuild: 
Flutter rebuilds the UI when setState is called, updating _message or _isButtonPressed to reflect changes like result messages or button animations. The FadeInAnimation widget uses AnimationController to dynamically animate UI elements.



##How to run?
git clone https://github.com/Hammad498/expense_tracker_summary.git
cd expense_tracker_summary
flutter pub get
flutter run






## Screen Shots

<img width="975" height="549" alt="image" src="https://github.com/user-attachments/assets/d0e5d85a-69cf-44ba-93ff-ecc2b77b4c16" />

#Expense Screen

<img width="975" height="548" alt="image" src="https://github.com/user-attachments/assets/2159e0da-672d-4a98-a962-f09c16da653f" />
<img width="975" height="545" alt="image" src="https://github.com/user-attachments/assets/b975296b-31a8-400b-baa7-f8ca828adb2d" />

<img width="975" height="548" alt="image" src="https://github.com/user-attachments/assets/d6c0e8e5-35b3-45bc-9c4e-405432467e2e" />









