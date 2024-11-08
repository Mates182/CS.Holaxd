FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["Holaxd/Holaxd.csproj", "Holaxd/"]
RUN dotnet restore "Holaxd/Holaxd.csproj"
COPY . .
WORKDIR "/src/Holaxd"
RUN dotnet build "Holaxd.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "Holaxd.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Holaxd.dll"]