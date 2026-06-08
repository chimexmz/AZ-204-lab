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

# Copy project file first for Docker layer caching
COPY ["FlightBooking.Api/FlightBooking.Api.csproj", "FlightBooking.Api/"]

# Restore dependencies
RUN dotnet restore "FlightBooking.Api/FlightBooking.Api.csproj"

# Copy source code
COPY . .

# Move into project directory
WORKDIR "/src/FlightBooking.Api"

# Publish optimized production build
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

# Copy published application
COPY --from=build /app/publish .

# Runtime environment variables
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Expose container port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Switch to non-root user
USER appuser

# Application startup
ENTRYPOINT ["dotnet", "FlightBooking.Api.dll"]
