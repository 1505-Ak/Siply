export const getAchievementIcon = (code: string) => {
  const map: Record<string, string> = {
    FIRST_DRINK: "party-popper",
    TEN_DRINKS: "star-circle",
    EXPLORER: "map-marker-radius",
    PERFECTIONIST: "trophy-variant", // 5-star rating
    LEGEND: "crown", // 100 drinks
    CONSISTENT: "fire", // Streaks
    DEDICATED: "arm-flex",
    VERSATILE: "palette", // All categories
  };

  // Default fallback if code doesn't match
  return map[code] || "trophy-outline";
};
