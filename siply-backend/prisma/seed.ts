import { prisma } from "../src/config/prisma";
import bcrypt from "bcryptjs";

async function main() {
  console.log("🌱 Starting Infrastructure Seed...");

  // ==========================================
  // 1. SEED VENUES
  // ==========================================
  await prisma.venue.create({
    data: {
      name: "The Espresso Lab",
      category: "Coffee",
      city: "London",
      address: "123 Coffee Lane",
      hasStudentDiscount: true,
      loyaltyPrograms: {
        create: {
          programType: "visitCard",
          visitCardGoal: 10,
          hasVisitCard: true,
        },
      },
      discounts: {
        create: {
          title: "Student 10% Off",
          discountPercentage: 10,
          requiresStudentId: true,
        },
      },
    },
  });
  console.log("✅ Seeded Venue");

  // ==========================================
  // 2. SEED ACHIEVEMENTS
  // ==========================================
  const achievements = [
    { code: "FIRST_DRINK", name: "First Sip", desc: "Logged your very first drink!", icon: "🎉", type: "DRINK_COUNT", val: 1 },
    { code: "TEN_DRINKS", name: "Regular", desc: "You’ve logged 10 drinks.", icon: "🌟", type: "DRINK_COUNT", val: 10 },
    { code: "EXPLORER", name: "Explorer", desc: "Visited 10 different locations.", icon: "🗺️", type: "LOCATION_COUNT", val: 10 },
  ];

  for (const ach of achievements) {
    await prisma.achievement.upsert({
      where: { code: ach.code },
      update: {},
      create: {
        code: ach.code,
        name: ach.name,
        description: ach.desc,
        icon: ach.icon,
        requirementType: ach.type,
        requirementValue: ach.val,
      },
    });
  }
  console.log("✅ Seeded Achievements");

  // ==========================================
  // 3. SEED USER ("tester")
  // ==========================================
  const passwordHash = await bcrypt.hash("password123", 10);

  await prisma.user.upsert({
    where: { username: "tester" },
    update: {},
    create: {
      username: "tester",
      email: "tester@siply.app",
      displayName: "Siply Tester",
      bio: "Coffee addict and cocktail enthusiast.",
      passwordHash,
      avatarUrl: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&h=200",
    },
  });
  console.log("✅ Seeded User: tester (password123)");
  console.log("🏁 Base Seeding Complete. Use Postman to add drinks via API.");
}

main()
  .catch((e) => console.error(e))
  .finally(async () => await prisma.$disconnect());