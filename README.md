# Flutter Shopping Cart App

A Flutter-based shopping cart app that fetches product data from an API and allows users to add, update, and remove items from their cart. It uses Riverpod for state management to handle the cart's state and calculate discounts.

## Features
- **Product Display**: Displays a list of products fetched from an API.
- **Add to Cart**: Users can add products to the shopping cart.
- **Increase/Decrease Quantity**: Users can increase or decrease the quantity of each product in the cart.
- **Price and Discount**: The original price of a product is shown with a strikethrough, and the discounted price is displayed next to it.
- **Shopping Cart**: The cart page shows all the products added, their quantities, and the total price.
- **Badge on Cart Icon**: The cart icon shows the number of items in the cart.

## Requirements
- Flutter 3.22.1
- Dart 3.4.1 • DevTools 2.34.3

## Setup Instructions

### 1. Clone the repository
Clone this repository to your local machine:
```bash
git clone https://github.com/yourusername/flutter-shopping-cart.git
```

### 2. Install dependencies
Navigate to the project directory and run the following command to install the required dependencies:
```bash
flutter pub get
```
### 3.Run the app
Once the dependencies are installed, you can run the app on your emulator or physical device:
```bash
flutter run
```
