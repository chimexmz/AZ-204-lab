namespace FlightBooking.Api.Contracts;

public record CreateBookingRequest(
    Guid FlightId,
    string PassengerName,
    string PassengerEmail,
    int SeatsBooked
);
