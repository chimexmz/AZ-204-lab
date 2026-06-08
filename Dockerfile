# =========================
# BUILD ARGUMENTS
# =========================
ARG DOTNET_VERSION=8.0.6
ARG ALPINE_VERSION=3.20
ARG BUILD_CONFIGURATION=Release

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

# Switch directory
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

WORKDIR /app

# Install wget for health checks
RUN apk add --no-cache wget

# Create non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy published app
COPY --from=build /app/publish .

# =========================
# ENVIRONMENT VARIABLES
# =========================
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Application Port
EXPOSE 8080

# =========================
# HEALTH CHECK
# =========================
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# =========================
# SECURITY
# =========================
USER appuser

# =========================
# APPLICATION STARTUP
# =========================
ENTRYPOINT ["dotnet", "FlightBooking.Api.dll"]
