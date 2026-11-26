# Build stage: resolve dependencies and compile a native executable.
FROM dart:3.11 AS build

WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get

COPY . .
RUN dart pub get --offline && dart compile exe bin/server.dart -o bin/server

# Runtime stage: only the binary and the Dart runtime libraries it needs.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server

EXPOSE 8082
CMD ["/app/bin/server"]
