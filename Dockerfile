# Use a stable .NET 8 base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy project file and restore dependencies
COPY ["Dashayin_Naicker_CV.csproj", "."]
RUN dotnet restore "./Dashayin_Naicker_CV.csproj"

# Copy everything else and build
COPY . .
RUN dotnet build "./Dashayin_Naicker_CV.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "./Dashayin_Naicker_CV.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final stage - runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Dashayin_Naicker_CV.dll"]
