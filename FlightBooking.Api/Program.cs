using FlightBooking.Api.Contracts;
using FlightBooking.Api.Data;
using FlightBooking.Api.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Best practice: enable Swagger only in Development
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapGet("/health", () => Results.Ok("Healthy"));

app.MapGet("/flights", () => Results.Ok(InMemoryStore.Flights));

app.MapPost("/bookings", (CreateBookingRequest request) =>
{
    var flight = InMemoryStore.Flights.FirstOrDefault(f => f.Id == request.FlightId);
    if (flight == null) return Results.NotFound("Flight not found");

    if (flight.AvailableSeats < request.SeatsBooked)
        return Results.BadRequest("Not enough seats");

    flight.AvailableSeats -= request.SeatsBooked;

    var booking = new Booking
    {
        FlightId = request.FlightId,
        PassengerName = request.PassengerName,
        PassengerEmail = request.PassengerEmail,
        SeatsBooked = request.SeatsBooked
    };

    InMemoryStore.Bookings.Add(booking);
    return Results.Created($"/bookings/{booking.Id}", booking);
});

app.Run();
