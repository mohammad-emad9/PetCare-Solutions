# 🐾 BookingRequests System

A Windows Forms application for pet care booking management, allowing pet owners to schedule appointments for their pets.

## ✨ Features

- **Phone Number Login** - Pet owners authenticate using their registered phone number
- **Pet Selection** - View and select from registered pets
- **Booking Scheduling** - Choose date and time for pet care appointments
- **SQL Server Integration** - Secure database connectivity

## 🛠️ Technology Stack

| Component | Technology |
|-----------|------------|
| Language | C# |
| Framework | .NET Framework 4.7.2 |
| UI | Windows Forms |
| Database | SQL Server |
| IDE | Visual Studio |

## 📋 Prerequisites

- **Windows OS** (Windows 10/11 recommended)
- **Visual Studio 2019+** with .NET Desktop Development workload
- **SQL Server** (LocalDB or full instance)
- **.NET Framework 4.7.2** Runtime

## 🗃️ Database Setup

1. Open SQL Server Management Studio (SSMS)
2. Execute the `PetCareSolutions` database schema:

```sql
-- Create database
CREATE DATABASE PetCareSolutions;
GO

-- Required tables: owners, pets, BookingRequests
```

3. Configure connection string in `App.config`:

```xml
<connectionStrings>
    <add name="BookingRequests_System.Properties.Settings.PetCareSolutionsConnectionString"
         connectionString="Data Source=localhost;Initial Catalog=PetCareSolutions;Integrated Security=True"
         providerName="System.Data.SqlClient" />
</connectionStrings>
```

## 🚀 Getting Started

1. **Clone/Download** the repository
2. **Open** `BookingRequests System.sln` in Visual Studio
3. **Build** the solution (Ctrl+Shift+B)
4. **Run** the application (F5)

## 📁 Project Structure

```
BookingRequests System/
├── BookingRequests System.sln          # Solution file
└── BookingRequests System/
    ├── Program.cs                      # Application entry point
    ├── LOGIN ONWERS.cs                 # Login form (phone authentication)
    ├── LOGIN ONWERS.Designer.cs        # Login form designer
    ├── Booking details.cs              # Booking form logic
    ├── Booking details.Designer.cs     # Booking form designer
    ├── App.config                      # Configuration settings
    ├── PetCareSolutionsDataSet.xsd     # Typed DataSet schema
    └── Properties/
        └── Settings.settings           # Application settings
```

## 📖 How It Works

1. **Login Screen** - Enter your registered phone number
2. **Pet Selection** - Select your pet from the dropdown
3. **Schedule** - Pick a date and time for the appointment
4. **Submit** - Send the booking request (status: Pending)

## 🔧 Configuration

Edit `App.config` to modify:
- Database connection string
- Supported .NET runtime version

## 📜 License

This project is for educational purposes.

---

**Developed for PetCare Solutions** 🐕 🐈
