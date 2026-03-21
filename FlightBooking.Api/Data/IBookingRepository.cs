using FlightBooking.Api.Contracts;
using FlightBooking.Api.Models;

namespace FlightBooking.Api.Data;

public interface IBookingRepository
{
    IEnumerable<Flight> GetFlights();
    IEnumerable<Booking> GetBookings();
    Booking? GetBookingById(Guid id);
    IEnumerable<Booking> SearchBookingsByEmail(string email);
    Booking? CreateBooking(CreateBookingRequest request);
}