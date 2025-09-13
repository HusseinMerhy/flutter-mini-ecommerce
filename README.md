
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


for sql in localhost:8080/h2-console( h2 instead oof Postegre and i cant add sql in intellij because it need ultimate version}

login and paste this script 




-- Insert sample products
INSERT INTO products (name, price, stock, image_url) VALUES 
('iPhone 15 Pro', 999.99, 50, 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=500&h=500&fit=crop'),
('MacBook Air M2', 1199.99, 30, 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500&h=500&fit=crop'),
('Sony WH-1000XM5', 349.99, 75, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop'),
('Nintendo Switch OLED', 349.99, 40, 'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=500&h=500&fit=crop'),
('Samsung 4K Smart TV', 599.99, 25, 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=500&h=500&fit=crop'),
('Canon EOS R5', 3899.99, 15, 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=500&h=500&fit=crop'),
('Apple Watch Series 9', 399.99, 60, 'https://images.unsplash.com/photo-1579586337278-3d4565c6e250?w=500&h=500&fit=crop'),
('Dyson V15 Detect', 699.99, 35, 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=500&h=500&fit=crop'),
('PlayStation 5', 499.99, 20, 'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=500&h=500&fit=crop'),
('Bose QuietComfort Earbuds', 279.99, 80, 'https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?w=500&h=500&fit=crop'),
('iPad Pro 12.9"', 1099.99, 45, 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop'),
('Kindle Paperwhite', 139.99, 100, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500&h=500&fit=crop'),
('GoPro HERO12 Black', 399.99, 55, 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=500&h=500&fit=crop'),
('AirPods Pro (2nd Gen)', 249.99, 90, 'https://images.unsplash.com/photo-1572536147248-ac59a8abfa4b?w=500&h=500&fit=crop'),
('Samsung Galaxy Z Fold5', 1799.99, 18, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop'),
('LG UltraWide Monitor', 799.99, 22, 'https://images.unsplash.com/photo-1551645120-d70bfe84c826?w=500&h=500&fit=crop'),
('Fitbit Charge 6', 159.99, 120, 'https://images.unsplash.com/photo-1575311373936-9ca857a7f114?w=500&h=500&fit=crop'),
('Xbox Series X', 499.99, 28, 'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=500&h=500&fit=crop'),
('DJI Mini 3 Pro', 759.99, 16, 'https://images.unsplash.com/photo-1506941433945-99f5c3d128e9?w=500&h=500&fit=crop'),
('Logitech MX Master 3S', 99.99, 65, 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500&h=500&fit=crop');
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
