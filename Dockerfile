# =========================
# BUILD ARGUMENTS
# =========================
ARG DOTNET_VERSION=8.0.6
ARG ALPINE_VERSION=3.20
ARG BUILD_CONFIGURATION=Release
ARG APP_VERSION=1.0.0
ARG BUILD_DATE

# =========================
# BUILD STAGE
# =========================
FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION}-alpine${ALPINE_VERSION} AS build

WORKDIR /src

# Copy project file for caching
COPY ["FlightBooking.Api/FlightBooking.Api.csproj", "FlightBooking.Api/"]

# Restore dependencies
RUN dotnet restore "FlightBooking.Api/FlightBooking.Api.csproj"

# Copy source code
COPY . .

# Move into project directory
WORKDIR "/src/FlightBooking.Api"

# Publish application
RUN dotnet publish "FlightBooking.Api.csproj" \
    -c ${BUILD_CONFIGURATION} \
    -o /app/publish \
    /p:UseAppHost=false

# =========================
# RUNTIME STAGE
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:${DOTNET_VERSION}-alpine${ALPINE_VERSION} AS final

# Metadata labels
LABEL maintainer="Chimezie Oji <your.email@example.com>" \
      org.opencontainers.image.title="FlightBooking API" \
      org.opencontainers.image.description="ASP.NET Core Flight Booking Microservice" \
      org.opencontainers.image.version=$APP_VERSION \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.authors="Chimezie Oji"

WORKDIR /app

# Install wget for health checks
RUN apk add --no-cache wget

# Create non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy published application
COPY --from=build /app/publish .

# Environment variables
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Switch to non-root user
USER appuser

# Start application
ENTRYPOINT ["dotnet", "FlightBooking.Api.dll"]
