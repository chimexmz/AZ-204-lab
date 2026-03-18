namespace FlightBooking.Api.Models;

public class Flight
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string FlightNumber { get; set; } = default!;
    public string From { get; set; } = default!;
    public string To { get; set; } = default!;
    public DateTime DepartureUtc { get; set; }
    public DateTime ArrivalUtc { get; set; }
    public decimal Price { get; set; }
    public int TotalSeats { get; set; }
    public int AvailableSeats { get; set; }
}


