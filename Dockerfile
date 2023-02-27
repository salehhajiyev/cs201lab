#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["simpleProj01/simpleProj01.csproj", "simpleProj01/"]
RUN dotnet restore "simpleProj01/simpleProj01.csproj"
COPY . .
WORKDIR "/src/simpleProj01"
RUN dotnet build "simpleProj01.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "simpleProj01.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "simpleProj01.dll"]