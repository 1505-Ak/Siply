package com.siply.backend.media;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class StorageConfig {

    @Value("${app.storage.provider:local}")
    private String provider;

    private final LocalFileStorageService localFileStorageService;
    private final S3StorageService s3StorageService;
    private final CloudinaryStorageService cloudinaryStorageService;

    public StorageConfig(LocalFileStorageService localFileStorageService,
                         S3StorageService s3StorageService,
                         CloudinaryStorageService cloudinaryStorageService) {
        this.localFileStorageService = localFileStorageService;
        this.s3StorageService = s3StorageService;
        this.cloudinaryStorageService = cloudinaryStorageService;
    }

    @Bean
    public StorageService storageService() {
        return switch (provider.toLowerCase()) {
            case "s3" -> s3StorageService;
            case "cloudinary" -> cloudinaryStorageService;
            default -> localFileStorageService;
        };
    }
}


