namespace FlightBooking.Api.Models;

public class Booking
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid FlightId { get; set; }
    public string PassengerName { get; set; } = default!;
    public string PassengerEmail { get; set; } = default!;
    public int SeatsBooked { get; set; }
    public DateTime CreatedUtc { get; set; } = DateTime.UtcNow;
    public string Status { get; set; } = "Confirmed";
}
