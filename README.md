# 🛒 Simple Product Lister 

แอปพลิเคชันแสดงรายการสินค้าจาก DummyJSON 
## API State Management (Loading, Data, Error): 
"โปรเจกต์นี้จัดการ State โดยใช้ ProductController (ChangeNotifier) เป็นศูนย์กลาง โดยจะแบ่งสถานะออกเป็น Loading (แสดง Indicator), Data (เมื่อโหลดสำเร็จ), และ Error (เมื่อเกิดข้อผิดพลาด) ซึ่ง UI จะทำการ Rebuild เฉพาะจุดผ่าน ListenableBuilder เพื่อประสิทธิภาพสูงสุด"

## 🚀 Features
- **Product List Screen**: แสดงรายการสินค้าพร้อมรูปภาพ ชื่อ และราคา พร้อมระบบ Loading Indicator
- **Error Handling**: จัดการกรณีไม่มีอินเทอร์เน็ตหรือ Server Error ด้วย UI ที่ชัดเจนและปุ่ม Retry
- **Product Detail Screen**: แสดงรายละเอียดสินค้าขนาดใหญ่ พร้อมคำอธิบายครบถ้วน
- **Pull-to-Refresh**: สามารถดึงหน้าจอเพื่ออัปเดตข้อมูลใหม่ได้

- **Advanced State Management**: ใช้ `ProductController` (ChangeNotifier) แยก Logic ออกจาก UI
- **Filtering**: กรองสินค้าตามหมวดหมู่ (Category) ได้
- **Robust Error Handling**: จัดการกรณี Offline หรือ API Error ด้วย Custom Exceptions และหน้าจอ Retry 
- **Type-Safe Data Model**: ป้องกันแอปแครชด้วยการทำ Data Mapping อย่างละเอียด (โดยไม่ใช้ `dynamic`)

## 🛠 Tech Stack & Architecture
- **Language**: Dart (Flutter Framework)
- **Architecture**: Controller Pattern (MVVM-like)
- **Networking**: `http` package
- **Image Caching**: `cached_network_image` เพื่อลดการใช้งาน Data และเพิ่มความลื่นไหลของ UI
- **Project Structure**: แบ่งเลเยอร์ตามหน้าที่ (Models, Services, Screens, Widgets)
- **Library**: 
  - `http`: สำหรับการเชื่อมต่อ API
  - `cached_network_image`: เพื่อการจัดการแคชรูปภาพที่มีประสิทธิภาพ
  - `mockito`, `build_runner`: สำหรับการทำ Unit Test (Mocking)
 
## 🤖 AI Tools Usage
มีการใช้งาน AI Tools (Gemini/ChatGPT) ในขั้นตอนดังนี้:
- Architecture Design: ช่วยร่างโครงสร้าง Folder ให้เป็นไปตาม Standard แนวทาง Clean Architecture
- Unit Testing: ช่วยในการร่างโครงสร้าง (Test Suite) สำหรับการทำ Unit Test เพื่อให้ครอบคลุมทุก Test Case (Edge Cases)
- Documentation: ช่วยแนะนำแนวทางการเขียน README และการจัดระเบียบเนื้อหาทางเทคนิคให้มีความเป็นสากลและเข้าใจง่าย

## 📁 Project Structure
```text
    lib/
    ├── core/             # ค่าคงที่และ Custom Exceptions (Error Handling)
    ├── models/           # ข้อมูลสินค้า (Type-safe Models)
    ├── controllers/      # Business Logic & State Management (ProductController)
    ├── services/         # API Service (Networking Layer)
    ├── screens/          # UI Screens (List & Detail)
    └── widgets/          # UI Components (ProductCard, ErrorView)
```

## 📸 Screenshots
<p align="center">
  <img width="280" alt="productList" src="https://github.com/user-attachments/assets/96da1cdd-4f4c-4b35-a0a7-8be86d2bd726" />
  <img width="280" alt="productDtail" src="https://github.com/user-attachments/assets/d9ab8dab-3197-4991-b096-09e9a1193572" />
</p>
