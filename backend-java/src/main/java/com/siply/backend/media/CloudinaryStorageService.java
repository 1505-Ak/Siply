package com.siply.backend.media;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@Service
public class CloudinaryStorageService implements StorageService {

    @Value("${app.storage.cloudinary.cloud-name:}")
    private String cloudName;
    @Value("${app.storage.cloudinary.api-key:}")
    private String apiKey;
    @Value("${app.storage.cloudinary.api-secret:}")
    private String apiSecret;

    @Override
    public String save(MultipartFile file) {
        if (cloudName.isBlank() || apiKey.isBlank() || apiSecret.isBlank()) {
            throw new IllegalStateException("Cloudinary not configured");
        }
        Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", cloudName,
                "api_key", apiKey,
                "api_secret", apiSecret
        ));
        try {
            Map uploadResult = cloudinary.uploader().upload(file.getBytes(), ObjectUtils.emptyMap());
            return uploadResult.get("secure_url").toString();
        } catch (IOException e) {
            throw new RuntimeException("Cloudinary upload failed", e);
        }
    }
}


