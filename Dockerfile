FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY Robust.Cdn/*.csproj ./Robust.Cdn/
RUN dotnet restore -r linux-x64

# copy everything else and build app
COPY Robust.Cdn/. ./Robust.Cdn/

WORKDIR /source/Robust.Cdn/
RUN dotnet publish -c release -r linux-x64 -o /app --no-self-contained --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0


WORKDIR /app
COPY --from=build /app ./

EXPOSE 5000

ENV DOTNET_ENVIRONMENT Production

VOLUME ["/app/builds"]

ENTRYPOINT ["/app/Robust.Cdn"]
