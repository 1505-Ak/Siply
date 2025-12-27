# Siply Java Backend

Spring Boot 3 + Java 21 replacement for the original Node/Express API. Goals:
- Keep REST routes compatible with the iOS client.
- Postgres primary DB with Flyway migrations.
- JWT auth, validation, and modular domains (auth, users, drinks, social, venues, achievements).

## Project layout
```
backend-java/
  build.gradle          # Dependencies and plugins
  settings.gradle
  src/main/java/com/siply/backend/
    SiplyBackendApplication.java
    health/HealthController.java
  src/main/resources/
    application.yml     # Env-driven config
    db/migration/       # Flyway migrations (V1 seeded from existing schema)
```

## Prerequisites
- Java 21
- Gradle 8+ (or use the wrapper once added)
- PostgreSQL running locally (default: db `siply`, user `postgres` / `postgres`)

## Quick start
```bash
cd backend-java
# if you have gradle installed: gradle bootRun
# or generate wrapper locally: gradle wrapper && ./gradlew bootRun
# API available at http://localhost:8080/health
```

To run against a local Postgres:
```bash
export DATABASE_URL=jdbc:postgresql://localhost:5432/siply
export DATABASE_USERNAME=postgres
export DATABASE_PASSWORD=postgres
gradle bootRun
```

## Docker
```bash
cd backend-java
docker-compose up --build
# API on http://localhost:8080/health, Postgres on 5432
```
Environment defaults are in `docker-compose.yml` (change `JWT_SECRET` for anything non-dev).

## API surface (high level)
- Auth: register, login, refresh (stored refresh tokens), me
- Users: profile get/update, drinks by user, stats, search
- Drinks: list/get/trending, create/update/delete
- Social: feed, follow/unfollow, followers/following, like/unlike, comments
- Venues: list/detail/nearby, discounts (student/happy-hour), loyalty lookup
- Achievements: list, user achievements, check
- Media: multipart upload -> returns URL

## Storage options
- Local (default): files saved under `UPLOADS_DIR` (default `uploads/`) and served from `/uploads/**`.
- S3: set `STORAGE_PROVIDER=s3` plus `S3_BUCKET`, `S3_REGION`, `S3_ACCESS_KEY`, `S3_SECRET_KEY`.
- Cloudinary: set `STORAGE_PROVIDER=cloudinary` plus `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`.

## OpenAPI & Postman
- Swagger UI at `/swagger-ui.html` (springdoc).
- Postman collection: `postman_collection.json`.

## Next steps
- Extend business rules (achievement unlock logic, feed enrichment, stats).
- Harden auth flows (device binding/rotation blacklists if needed).
- Add more integration and contract tests per endpoint.


