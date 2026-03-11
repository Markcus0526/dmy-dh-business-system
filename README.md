# 鼎圣汇 (Ding Sheng Hui / DSH) Business System

A comprehensive cross-platform business management system providing mobile and web-based services for financial transactions, product management, and business operations.

## Overview

鼎圣汇 (Ding Sheng Hui) is a business system designed to facilitate financial services, product trading, and business management. The system consists of multiple components including mobile applications (Android & iOS), web services, and web-based management portals.

## Project Structure

```
dmy-dh-business-system/
├── Android/               # Android Mobile Application
├── iOS/                   # iOS Mobile Application
├── WebService/            # WCF Web Service (API Layer)
├── WebSite/               # ASP.NET Web Applications
│   ├── Backend/           # Admin/Management Portal
│   └── Frontend/          # Customer-facing Portal
├── Database/              # SQL Server Database Files
│   └── Development/       # Design Documents & Prototypes
└── README.md
```

## Technology Stack

### Mobile Applications

| Platform | Technology | Framework/Libraries |
|----------|------------|---------------------|
| Android  | Java       | AsyncHttpClient, Pull-to-Refresh, SmartImageView |
| iOS      | Objective-C| AFNetworking, Storyboard-based UI |

### Backend Services

| Component | Technology | Framework |
|-----------|------------|-----------|
| Web Service | C# .NET | WCF (Windows Communication Foundation) |
| Frontend Portal | ASP.NET MVC 3 | Razor View Engine |
| Backend Portal | ASP.NET MVC 3 | Razor View Engine |
| Database | SQL Server | LINQ to SQL |

### Key Libraries

- **JSON Processing:** Newtonsoft.Json
- **HTTP Client:** AsyncHttpClient (Android), AFNetworking (iOS)
- **UI Components:** Custom pull-to-refresh, wheel date/time pickers

## Features

### Mobile Application Features

- **User Authentication**
  - Login/Logout
  - User Registration
  - Password Reset (via SMS verification)
  - Profile Management

- **Product Management**
  - Product Catalog & Categories
  - Product Search
  - Product Details
  - Recommended Products

- **Order Management**
  - Order Creation & Upload
  - Order History
  - Order Status Tracking
  - Order Evaluation

- **Financial Services**
  - Business Money Application
  - Payment Processing
  - Transaction History

- **Business Services**
  - Service Application
  - Service Upload
  - Service Details

- **Additional Features**
  - Photo Selection/Capture
  - Location Services (Baidu Maps)
  - Credit Card/Bank Card Integration

### Web Portal Features

#### Frontend (Customer Portal)
- User Account Management
- Product Browsing
- Financial Services
- Order Management
- Sales Tracking

#### Backend (Admin Portal)
- User Account Administration
- Shop Management
- Product Catalog Management
- Card/Payment Management
- Region Management
- Device Management
- Financial Transactions
- Sales Analytics
- Upload Management

## API Endpoints (Web Service)

The WCF Web Service provides the following key endpoints:

### Authentication
- `LoginUser` - User login with credentials and device info
- `RegisterUser` - New user registration
- `ReqVerifyKey` - Request SMS verification code
- `ConfirmVerifyKey` - Verify SMS code
- `ResetPassword` - Password reset functionality

### User Management
- `GetUserInfo` - Retrieve user profile
- `UpdateUserInfo` - Update user information

### Products
- `GetRecommendGoodList` - Get featured/recommended products
- `GetGoodKindList` - Get product categories
- `GetGoodsList` - Get product list with pagination
- `FindGoodsList` - Search products
- `GetGoodDetailInfo` - Get product details

### Services
- `GetServiceList` - Get available services
- `AddServiceItem` - Apply for a service

### Orders
- `GetMyOrderList` - Get user's order history
- `GetGoodOrderInfo` - Get order details
- `UploadOrderInfo` - Create/update order
- `SetGoodEval` - Submit product evaluation

### Financial
- `AddBusinessMoney` - Apply for business financing

## Database

The system uses SQL Server with the following main tables:
- `tbl_admin` - Administrators
- `tbl_adminroles` - Admin roles/permissions
- `tbl_shops` - Shop accounts
- `tbl_users` - End users
- Products, Orders, Services, and more...

## Development Documentation

Refer to the `Document/Development/` directory for:
- Service Design Documentation
- Database Design (Excel)
- System Requirements Specification
- UI/UX Prototypes

## Project Configuration

### Database Configuration
- Database files: `Database/DSH.mdf` and `DSH_log.ldf`
- Connection strings in respective project config files

### Mobile App Configuration
- Service endpoint URLs defined in app constants
- Payment integration: UPPayPlugin (银联支付)

## Building & Deployment

### Prerequisites
- Android Studio / Eclipse for Android
- Xcode for iOS
- Visual Studio 2010+ for .NET components
- SQL Server 2008+

### Database Setup
1. Attach the SQL Server database files
2. Update connection strings in configuration files

### Web Service Setup
1. Open solution in Visual Studio
2. Configure web.config with database connection
3. Deploy to IIS or run locally

### Website Setup
1. Open Backend/Frontend solutions
2. Configure Web.config
3. Deploy to IIS

## License

Copyright © 2014. All rights reserved.

## Version

- Project Version: 1.0
- Last Updated: 2014

