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

The API uses **in‑memory storage** (no database yet) to keep the focus on API design and deployment concepts relevant to AZ‑204.

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