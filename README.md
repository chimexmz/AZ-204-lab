# AZ-204 Lab – Flight Booking API
App Service deployment

This repository contains a **simple ASP.NET Core Web API** built as part of an **AZ‑204 (Developing Solutions for Microsoft Azure)** hands‑on lab.

The project demonstrates:
- Building a Minimal API using ASP.NET Core
- Running the application fully in **GitHub Codespaces** (no local setup)
- Using **Swagger (OpenAPI)** for API exploration
- Implementing basic in‑memory business logic
- Preparing the application for **Azure App Service deployment**

---

## 🧱 Project Overview

The application is a **Flight Booking API** that allows:

- Health check validation
- Retrieving available flights
- Creating flight bookings with seat availability checks
- Retrieving all bookings
- Retrieving a booking by ID with 404 handling
- Searching bookings by passenger email

The API uses **in‑memory storage** (no database yet) to keep the focus on API design and deployment concepts relevant to AZ‑204.

---

## 🧩 Implementation details

1. Setup
   - Created new ASP.NET Core Minimal API project in `FlightBooking.Api`.
   - Added project references and kept dependency footprint small to match AZ-204 lab scope.
   - Enabled Swagger via `builder.Services.AddEndpointsApiExplorer()` and `builder.Services.AddSwaggerGen()`.
   - Configured Swagger to run only in development (`app.UseSwagger()` and `app.UseSwaggerUI()` inside `if (app.Environment.IsDevelopment())`).

2. Data model and in-memory storage
   - Added `Models/Flight.cs` and `Models/Booking.cs` to define domain entities.
   - Added `Contracts/CreateBookingRequest.cs` for incoming booking payload validation.
   - Added `Data/InMemoryStore.cs` with static collections for `Flights` and `Bookings`.

3. API endpoints (in `Program.cs`)
   - Health: `GET /health` returns `200 OK` with message.
   - Flights: `GET /flights` returns all available flights from store.
   - Bookings:
     - `GET /bookings` returns all bookings.
     - `GET /bookings/{id:guid}` returns a booking by ID or `404` when not found.
     - `GET /bookings/search?email={email}` filters bookings by email (case-insensitive).
     - `POST /bookings` creates a booking with:
       - flight existence check (`404` if missing),
       - `SeatsBooked > 0` validation (`400` if invalid),
       - available seats check (`400` if not enough),
       - seat count deduction and booking creation; returns `201 Created` with location.

4. Testing and validation
   - Verified endpoints via Swagger UI running on local development server.
   - Confirmed flow of available-seat decrement on successful booking and proper error handling.

---

## 🛠️ Tech Stack

- **.NET (ASP.NET Core Minimal APIs)**
- **Swagger / OpenAPI** via Swashbuckle
- **GitHub Codespaces** (cloud‑based development environment)
- **C#**

---

## 📂 Project Structure

```text
FlightBooking.Api/
│
├── Contracts/
│   └── CreateBookingRequest.cs
│
├── Data/
│   └── InMemoryStore.cs
│
├── Models/
│   ├── Flight.cs
│   └── Booking.cs
│
├── Program.cs
├── FlightBooking.Api.csproj
└── README.md