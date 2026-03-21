# AZ-204 Lab – Flight Booking API

Overview

This repository contains a Flight Booking Web API built with ASP.NET Core (Minimal APIs) as part of an AZ‑204 (Developing Solutions for Microsoft Azure) hands‑on lab.
The project focuses on API design, cloud‑native development, and DevOps fundamentals, progressing from local development to automated CI using GitHub Actions, and preparing the application for Azure App Service deployment.

The project demonstrates:
- Building a Minimal API using ASP.NET Core
- Running the application fully in **GitHub Codespaces** (no local setup)
- Using **Swagger (OpenAPI)** for API exploration
- Implementing basic in‑memory business logic
- Preparing the application for **Azure App Service deployment**

---

## 🧱  Application Overview

The application is a **Flight Booking API** that supports the following functionality:

Core Features

- Health check validation
- Retrieving available flights
- Creating flight bookings with seat availability checks
- Retrieving all bookings
- Retrieving a booking by ID with 404 handling
- Searching bookings by passenger email

Design Notes

- The application uses in‑memory storage (no database yet) to keep the focus on:
- API behavior
- Request/response handling
- Validation and error handling
- Cloud deployment readiness
- This approach aligns with the learning objectives of AZ‑204, before introducing persistence services such as Azure SQL or Cosmos DB.

---

## 🧩 Implementation details

1. Project Setup
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

 ## 🧪 Testing & Validation

   - Verified all endpoints via Swagger UI
     Confirmed:
   - Seat availability decreases correctly after booking
   - Proper HTTP status codes for validation and error scenarios
   - Clean request/response behavior


---

## 🚀 DevOps & Automation

1. Continuous Integration (CI)

   - Implemented GitHub Actions for CI
   - Workflow is located at: 
   github/workflows/deploy.yml

2. CI pipeline performs:

   - Source checkout
   - .NET 8 setup
   - Dependency restore
   - Release build validation
   - Triggered automatically on every push to the main branch
   - ** This ensures the application always builds successfully before deployment **

3. Containerization (Optional Path)

   - Added a multi‑stage Dockerfile:
   - Build stage using mcr.microsoft.com/dotnet/sdk:8.0
   - Runtime stage using mcr.microsoft.com/dotnet/aspnet:8.0
   - Application runs on port 8080, aligned with cloud‑native defaults
   - Container builds and runs successfully locally and in Codespaces

## 🛠️ Tech Stack

- .NET 8 / ASP.NET Core (Minimal APIs)
- **Swagger / OpenAPI** via Swashbuckle
- GitHub Codespaces (cloud‑based development environment)
- C#
- GitHub Actions (CI)
- Docker


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


-----

## 🔜 Next Steps

 - The next phase of this lab will focus on deployment and cloud integration, including:
 - Deploying the API to Azure App Service (Linux, .NET 8)
 - Authenticating GitHub Actions to Azure using OpenID Connect (OIDC)
 - Automating Continuous Deployment (CD)
 - (Optional) Introducing Azure‑managed data services