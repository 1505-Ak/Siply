# Siply Backend (Node.js & TypeScript)

This is the official backend for **Siply**, a drink journal and discovery application. It manages user authentication, drink logging, social interactions, venue discovery, and a complex loyalty/achievement system.

## 🚀 Tech Stack
- **Runtime:** Node.js (ES Modules)
- **Language:** TypeScript
- **Framework:** Express.js
- **ORM:** Prisma
- **Database:** PostgreSQL
- **Image Handling:** Multer (Local Storage)
- **Security:** JWT (JSON Web Tokens) & BcryptJS

---

## 🛠️ Getting Started

### Prerequisites
- **Node.js:** v18.x or higher
- **PostgreSQL:** Running locally or via Docker
- **npm** or **yarn**

### 1. Installation
```bash
git clone <repository-url>
cd siply-node-backend
npm install
```

### 2. Environment Setup
Create a `.env` file in the root directory:
```env
PORT=8080
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/siply?schema=public"
JWT_SECRET="your_super_secret_random_string"
```

### 3. Database Initialization
This project uses **Prisma** for database management.
1. Generate the Prisma Client:
   ```bash
   npx prisma generate
   ```
2. Run migrations to create tables in your Postgres DB:
   ```bash
   npx prisma migrate dev --name init
   ```
3. (Optional) Seed the database with initial venues and achievements:
   ```bash
   npx prisma db seed
   ```
*For detailed Prisma setup, refer to the [Official Prisma Documentation](https://www.prisma.io/docs/getting-started/setup-prisma/add-to-existing-project/relational-databases/typescript-postgres).*

### 4. Running the Server
```bash
# Development mode (with hot-reload)
npm run dev

# Production build
npm run build
npm start
```

---

## 📡 API Reference

All protected routes require an `Authorization: Bearer <token>` header.

### 1. Authentication (`/api/auth`)
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/register` | Create a new user account |
| `POST` | `/login` | Authenticate and receive tokens |
| `POST` | `/refresh` | Get a new Access Token using a Refresh Token |
| `GET` | `/me` | Get the current authenticated user's profile |

### 2. Media & Uploads (`/api/media`)
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/upload` | Upload an image (Multipart Form Data). Returns a URL. |

### 3. Drink Journal (`/api/drinks`)
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/` | List all drinks for the authenticated user |
| `POST` | `/` | Log a new drink (automatically creates a feed post) |
| `GET` | `/trending/all` | Get a list of drinks globally sorted by likes |
| `DELETE` | `/:id` | Delete a specific drink log |

### 4. Social Features (`/api/social`)
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/feed` | Get global activity feed of all users |
| `POST` | `/follow/:userId` | Follow a user |
| `DELETE` | `/follow/:userId`| Unfollow a user |
| `POST` | `/likes/:drinkId` | Like a drink |
| `DELETE` | `/likes/:drinkId`| Remove a like |
| `GET` | `/comments/:drinkId`| Get all comments for a drink |
| `POST` | `/comments/:drinkId`| Add a comment to a drink |

### 5. Venues & Loyalty (`/api/venues`)
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/` | List all venues (Supports `?city=` and `?category=`) |
| `GET` | `/deals/student` | Find venues offering student discounts |
| `GET` | `/deals/happy-hour`| Find venues with active Happy Hours |
| `GET` | `/me/progress` | Get user's points/stamps progress across all venues |
| `POST` | `/:venueId/visit` | Record a visit (adds points/punches card) |

### 6. Achievements (`/api/achievements`)
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/` | List the full catalog of available achievements |
| `GET` | `/user` | List achievements unlocked by the current user |
| `POST` | `/check` | Trigger server-side calculation of newly earned trophies |

### 7. User Discovery (`/api/users`)
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/search?q=...` | Search for users by username or display name |
| `PUT` | `/profile` | Update bio, avatar URL, or signature drink |
| `GET` | `/:username` | View a user's public profile and stats |

---

## 🛠️ Development & Debugging
- **Prisma Studio:** Run `npx prisma studio` to open a GUI for viewing and editing your database data.
- **Ngrok:** If testing on a physical mobile device, use `ngrok http 8080`.
  - *Note:* Add the header `ngrok-skip-browser-warning: 69420` in your frontend client to bypass the ngrok landing page.

## 📁 Project Structure
```text
src/
  ├── config/      # Prisma, JWT, and Env configuration
  ├── controllers/ # Route handlers (Business logic)
  ├── middleware/  # Auth protection and Error handling
  ├── routes/      # Express route definitions
  ├── index.ts     # Server entry point
prisma/
  ├── schema.prisma # Database Models & Relationships
  └── seed.ts      # Initial data (Achievements/Venues)
```

***
