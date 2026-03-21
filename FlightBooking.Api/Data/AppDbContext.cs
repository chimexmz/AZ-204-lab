using FlightBooking.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace FlightBooking.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Flight> Flights { get; set; } = null!;
    public DbSet<Booking> Bookings { get; set; } = null!;
}