# Siply

SwiftUI iOS app + Java (Spring Boot) backend. This repo only contains what we ship today: the iOS client and the Java backend.

## Repo layout
- `Siply/` — iOS app (SwiftUI)
- `backend-java/` — Spring Boot API used by the app

## Requirements
- Xcode 15+, iOS 17+ simulator or device
- Java 21, Gradle wrapper included
- Docker (optional) if you prefer containerized backend + Postgres

## iOS app quick start
```bash
cd /Users/anulomekishore/Downloads/Siply
open Siply.xcodeproj
# In Xcode: select a team for signing, choose a simulator/device, press ⌘R
```

## Java backend quick start
```bash
cd /Users/anulomekishore/Downloads/Siply/backend-java
./gradlew bootRun
# API health: http://localhost:8080/health
```

Env vars (override defaults in `application.yml`):
```
DATABASE_URL=jdbc:postgresql://localhost:5432/siply
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
JWT_SECRET=dev-secret
```

### Docker option
```bash
cd /Users/anulomekishore/Downloads/Siply/backend-java
docker-compose up --build
# API on 8080, Postgres on 5432
```

Docs:
- Swagger UI: `/swagger-ui.html`
- Postman: `backend-java/postman_collection.json`

---

**Built using Swift, Java, PostgreSQL, and Spring Boot**
