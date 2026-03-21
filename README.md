AZ‑204 Lab – Flight Booking API
Overview
This repository contains a Flight Booking Web API built with ASP.NET Core (Minimal APIs) as part of an AZ‑204 (Developing Solutions for Microsoft Azure) hands‑on lab.
The project focuses on API design, cloud‑native development, and DevOps fundamentals, progressing from local development to automated CI using GitHub Actions, and preparing the application for Azure App Service deployment.

✅ What Has Been Achieved So Far
This project demonstrates the following key capabilities:

✅ Building a Minimal API using ASP.NET Core (.NET 8)
✅ Running the application fully in GitHub Codespaces (no local setup required)
✅ Exposing and testing endpoints using Swagger / OpenAPI
✅ Implementing in‑memory business logic for rapid prototyping
✅ Structuring the project according to clean API design principles
✅ Containerizing the application using Docker (multi‑stage build)
✅ Implementing Continuous Integration (CI) using GitHub Actions
✅ Automatically validating builds on every push to the main branch
✅ Preparing the application for Azure App Service deployment


🧱 Application Overview
The Flight Booking API supports the following functionality:
Core Features

Health check validation
Retrieve available flights
Create flight bookings with seat availability checks
Retrieve all bookings
Retrieve a booking by ID (with proper 404 handling)
Search bookings by passenger email

Design Notes

The application uses in‑memory storage (no database yet) to keep the focus on:

API behavior
Request/response handling
Validation and error handling
Cloud deployment readiness


This approach aligns with the learning objectives of AZ‑204, before introducing persistence services such as Azure SQL or Cosmos DB.


🧩 Implementation Details
Project Setup

Created an ASP.NET Core Minimal API project in FlightBooking.Api
Kept dependencies intentionally small to match AZ‑204 lab scope
Enabled Swagger using:
Shellbuilder.Services.AddEndpointsApiExplorer();builder.Services.AddSwaggerGen();Show more lines

Configured Swagger to run only in Development:
Shellif (app.Environment.IsDevelopment()){    app.UseSwagger();    app.UseSwaggerUI();}Show more lines



Data Model & In‑Memory Storage

Models

Models/Flight.cs – Represents available flights
Models/Booking.cs – Represents a booking record


Contracts

Contracts/CreateBookingRequest.cs – Validates incoming booking requests


Data Store

Data/InMemoryStore.cs – Static in‑memory collections for flights and bookings




API Endpoints (Program.cs)
Health

GET /health
Returns 200 OK with a simple health message.

Flights

GET /flights
Returns all available flights.

Bookings

GET /bookings
Returns all bookings.
GET /bookings/{id:guid}
Returns a booking by ID or 404 if not found.
GET /bookings/search?email={email}
Filters bookings by passenger email (case‑insensitive).
POST /bookings
Creates a booking with:

Flight existence validation (404 if missing)
Seat count validation (400 if invalid)
Available‑seat check (400 if insufficient)
Seat deduction and booking creation
Returns 201 Created with location header.




🧪 Testing & Validation

Verified all endpoints via Swagger UI
Confirmed:

Seat availability decreases correctly after booking
Proper HTTP status codes for validation and error scenarios
Clean request/response behavior




🚀 DevOps & Automation
Continuous Integration (CI)

Implemented GitHub Actions for CI
Workflow is located at:
.github/workflows/deploy.yml


CI pipeline performs:

Source checkout
.NET 8 setup
Dependency restore
Release build validation


Triggered automatically on every push to the main branch

✅ This ensures the application always builds successfully before deployment.

Containerization (Optional Path)

Added a multi‑stage Dockerfile:

Build stage using mcr.microsoft.com/dotnet/sdk:8.0
Runtime stage using mcr.microsoft.com/dotnet/aspnet:8.0


Application runs on port 8080, aligned with cloud‑native defaults
Container builds and runs successfully locally and in Codespaces


🛠️ Tech Stack

.NET 8 / ASP.NET Core (Minimal APIs)
C#
Swagger / OpenAPI (Swashbuckle)
GitHub Codespaces
GitHub Actions (CI)
Docker


📂 Project Structure
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


🔜 Next Steps
The next phase of this lab will focus on deployment and cloud integration, including:

Deploying the API to Azure App Service (Linux, .NET 8)
Authenticating GitHub Actions to Azure using OpenID Connect (OIDC)
Automating Continuous Deployment (CD)
(Optional) Introducing Azure‑managed data services


✅ Status: CI complete
🚧 In progress: Azure App Service deployment



