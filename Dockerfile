FROM mcr.microsoft.com/dotnet/core/aspnet:3.0.0-alpine AS base
RUN apk update && apk add --no-cache libc6-compat && echo "Added lib for firebase [1]"
RUN ln -s /lib/ld-musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2 && echo "Added lib for firebase [2]"
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-alpine AS build
RUN apk update && apk add --no-cache libc6-compat && echo "Added lib for firebase [1]"
RUN ln -s /lib/ld-musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2 && echo "Added lib for firebase [2]"
RUN dotnet --version
WORKDIR /src
COPY ["Firestore.Crash/Firestore.Crash.csproj", "Firestore.Crash/"]
RUN dotnet restore "Firestore.Crash/Firestore.Crash.csproj"
COPY . .

WORKDIR "/src/Firestore.Crash"
RUN dotnet build "Firestore.Crash.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Firestore.Crash.csproj" /p:TreatWarningsAsErrors=true /warnaserror -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Firestore.Crash.dll"]
