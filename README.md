
# Flutter E-Commerce App 🛒

A fully functional Flutter-based e-commerce application featuring authentication, cart management, and order processing. Built with a focus on backend integration, state management, and persistent storage.


## 🌟 Features

- **Authentication**
  - User login, registration, and logout
  - JWT-based role management (Admin/User)
  - Secure storage of token and user info via `SharedPreferences`
- **Cart Management**
  - Add, remove, clear, and update product quantities
  - Calculates total price and quantity
  - Persistent cart per user using local storage
- **Backend Focus**
  - API integration for authentication
  - Role extraction and validation from JWT
  - Order items formatted for backend submission

---

## 🗂 Screens / Modules

1. **Authentication**
   - Login, Register, Logout
   - Role-based access control (`isAdmin`, `isAuthenticated`)
2. **Cart**
   - Product addition, removal, quantity management
   - Load/save cart locally per user
   - Prepare order payloads for backend API

---

## 🧩 State Management

- **Provider** is used to manage app state:
  - AuthProvider: handles login, registration, JWT decoding, and role management
  - CartProvider: handles cart logic and persistent storage per user

---

## 🚀 How to Run

1. Clone the repository:

bash
git clone https://github.com/your-username/your-repo.git
cd your-repo


2. Install dependencies:

bash
flutter pub get


3. Run the app:

bash
flutter run


> Ensure your backend API is running or mock responses for demonstration.

---

## ⚡ Assumptions

* Backend API provides JWT token, user ID, roles, and product info.
* Product `stock` is numeric and reliable.
* Role names are `ROLE_ADMIN` or `ROLE_USER`.
* Cart is stored locally per user; backend sync is not implemented yet.

---

## 🎯 Trade-offs

* **Local Storage vs Backend**: Opted for `SharedPreferences` for speed; full backend cart sync is deferred.
* **JWT Decoding**: Assumes roles claim is a string or list in the token.
* **Error Handling**: Minimal for MVP; assumes correct API response structure.
* **UI Feedback**: Success/error messages are functional but simple.

---

## ⏱ Time Spent & Learning

* **Backend Integration & API Logic**: \~15 hours
* **Authentication & JWT Management**: \~10 hours
* **Cart Module & Local Storage**: \~8 hours
* **Testing & Debugging**: \~4 hours

*Total: \~37 hours* 🕒

> Focused heavily on backend logic, API integration, and understanding JWT-based role management. Learned a lot about Flutter state management, secure storage, and designing scalable provider structures.

---

## ✅ Minimal Tests

* AuthProvider:

  * Login, logout, role detection
* CartProvider:

  * Add/remove items, quantity updates, clear cart

---

## 📂 Folder Structure


lib/
 ├─ providers/
 │   ├─ auth_provider.dart
 │   └─ cart_provider.dart
 ├─ screens/
 ├─ services/
 │   └─ api_service.dart
 └─ main.dart


---

## 💡 Notes

* Clean commits with meaningful messages.
* Focused on backend and data flow rather than flashy UI.
* Designed to be easily extendable for admin functionality and full backend integration.

---
