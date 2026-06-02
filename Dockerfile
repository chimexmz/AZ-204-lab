# =========================
# BUILD STAGE
# =========================
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

WORKDIR /src

# Copy project file first for Docker layer caching
COPY ["FlightBooking.Api/FlightBooking.Api.csproj", "FlightBooking.Api/"]

# Restore dependencies
RUN dotnet restore "FlightBooking.Api/FlightBooking.Api.csproj"

# Copy entire source code
COPY . .

# Move into project directory
WORKDIR "/src/FlightBooking.Api"

# Publish optimized release build
RUN dotnet publish "FlightBooking.Api.csproj" \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

# =========================
# RUNTIME STAGE
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS final

WORKDIR /app

# Create non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy published application
COPY --from=build /app/publish .

# Configure ASP.NET Core
ENV ASPNETCORE_URLS=http://+:8080

# Expose application port
EXPOSE 8080

# Switch to non-root user
USER appuser

# Start application
ENTRYPOINT ["dotnet", "FlightBooking.Api.dll"]
