package com.siply.backend.media;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@Service
public class S3StorageService implements StorageService {

    @Value("${app.storage.s3.bucket:}")
    private String bucket;

    @Value("${app.storage.s3.region:us-east-1}")
    private String region;

    @Value("${app.storage.s3.access-key:}")
    private String accessKey;

    @Value("${app.storage.s3.secret-key:}")
    private String secretKey;

    @Override
    public String save(MultipartFile file) {
        if (bucket.isBlank() || accessKey.isBlank() || secretKey.isBlank()) {
            throw new IllegalStateException("S3 storage not configured");
        }
        S3Client client = S3Client.builder()
                .region(Region.of(region))
                .credentialsProvider(StaticCredentialsProvider.create(
                        AwsBasicCredentials.create(accessKey, secretKey)
                ))
                .build();
        String key = UUID.randomUUID() + "-" + (file.getOriginalFilename() != null ? file.getOriginalFilename() : "upload");
        try {
            client.putObject(
                    PutObjectRequest.builder()
                            .bucket(bucket)
                            .key(key)
                            .contentType(file.getContentType())
                            .build(),
                    software.amazon.awssdk.core.sync.RequestBody.fromBytes(file.getBytes())
            );
        } catch (IOException e) {
            throw new RuntimeException("Failed to upload to S3", e);
        }
        String encodedKey = URLEncoder.encode(key, StandardCharsets.UTF_8);
        return "https://" + bucket + ".s3." + region + ".amazonaws.com/" + encodedKey;
    }
}


