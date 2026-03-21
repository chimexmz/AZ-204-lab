using FlightBooking.Api.Contracts;
using FlightBooking.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace FlightBooking.Api.Data;

public class BookingRepository : IBookingRepository
{
    private readonly AppDbContext _context;

    public BookingRepository(AppDbContext context)
    {
        _context = context;
    }

    public IEnumerable<Flight> GetFlights()
    {
        return _context.Flights.AsNoTracking().ToList();
    }

    public IEnumerable<Booking> GetBookings()
    {
        return _context.Bookings.AsNoTracking().ToList();
    }

    public Booking? GetBookingById(Guid id)
    {
        return _context.Bookings.AsNoTracking().FirstOrDefault(b => b.Id == id);
    }

    public IEnumerable<Booking> SearchBookingsByEmail(string email)
    {
        return _context.Bookings
            .AsNoTracking()
            .Where(b => b.PassengerEmail.Equals(email, StringComparison.OrdinalIgnoreCase))
            .ToList();
    }

    public Booking? CreateBooking(CreateBookingRequest request)
    {
        var flight = _context.Flights.FirstOrDefault(f => f.Id == request.FlightId);
        if (flight == null)
            return null;

        if (request.SeatsBooked <= 0)
            return null;

        if (flight.AvailableSeats < request.SeatsBooked)
            return null;

        flight.AvailableSeats -= request.SeatsBooked;

        var booking = new Booking
        {
            FlightId = request.FlightId,
            PassengerName = request.PassengerName,
            PassengerEmail = request.PassengerEmail,
            SeatsBooked = request.SeatsBooked
        };

        _context.Bookings.Add(booking);
        _context.SaveChanges();

        return booking;
    }
}