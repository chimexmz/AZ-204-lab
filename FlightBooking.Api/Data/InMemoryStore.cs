using FlightBooking.Api.Models;

namespace FlightBooking.Api.Data;

public static class InMemoryStore
{
    public static List<Flight> Flights { get; } = SeedFlights();
    public static List<Booking> Bookings { get; } = new();

    private static List<Flight> SeedFlights()
    {
        var baseTime = DateTime.UtcNow.Date.AddDays(1);
        return new List<Flight>
        {
            new()
            {
                FlightNumber = "AZ204",
                From = "LIS",
                To = "LHR",
                DepartureUtc = baseTime.AddHours(8),
                ArrivalUtc = baseTime.AddHours(10),
                Price = 250,
                TotalSeats = 180,
                AvailableSeats = 180
            }
        };
    }
}
