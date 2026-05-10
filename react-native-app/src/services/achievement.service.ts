import { getAchievementIcon } from "../utils/achievementIcons";
import { api } from "./api.service";

export const achievementService = {
  // We fetch everything in one go to ensure consistency,
  // then helper methods below filter it.
  getData: async () => {
    try {
      // 1. Trigger a check to ensure latest stats are calculated
      // (Optional, but good if the user just logged a drink)
      // await api.post('/achievements/check', {});

      // 2. Fetch Catalog and Unlocked status
      const [allAchievements, unlockedRecords] = await Promise.all([
        api.get("/achievements"),
        api.get("/achievements/user"),
      ]);

      // Create a Set of unlocked IDs for O(1) lookup
      const unlockedIds = new Set(
        unlockedRecords.map((r: any) => r.achievementId),
      );

      // Merge data
      const processedList = allAchievements.map((item: any) => ({
        id: item.id,
        name: item.name,
        desc: item.description,
        icon: getAchievementIcon(item.code),
        unlocked: unlockedIds.has(item.id),
      }));

      return processedList;
    } catch (error) {
      console.error("Achievement fetch error", error);
      return [];
    }
  },

  getUserProgress: async () => {
    const list = await achievementService.getData();
    const unlockedCount = list.filter((i: any) => i.unlocked).length;
    const total = list.length;

    return {
      unlocked: unlockedCount,
      locked: total - unlockedCount,
      total: total,
      progressPercentage:
        total === 0 ? 0 : Math.round((unlockedCount / total) * 100),
    };
  },

  getAllAchievements: async () => {
    return await achievementService.getData();
  },
};
