package com.siply.backend.achievements;

import com.siply.backend.users.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AchievementService {

    private final AchievementRepository achievementRepository;
    private final UserAchievementRepository userAchievementRepository;

    public List<Achievement> all() {
        return achievementRepository.findAll();
    }

    public List<UserAchievement> forUser(User user) {
        return userAchievementRepository.findByUser(user);
    }

    public List<UserAchievement> check(User user) {
        // Placeholder for real rules: return current user achievements
        return forUser(user);
    }
}


