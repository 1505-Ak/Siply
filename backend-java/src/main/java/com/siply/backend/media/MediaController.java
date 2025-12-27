package com.siply.backend.media;

import com.siply.backend.users.User;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/media")
@RequiredArgsConstructor
public class MediaController {

    private final StorageService storageService;

    @PostMapping("/upload")
    public ResponseEntity<UploadResponse> upload(
            @AuthenticationPrincipal User user,
            @RequestParam("file") MultipartFile file
    ) {
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        String url = storageService.save(file);
        return ResponseEntity.status(HttpStatus.CREATED).body(new UploadResponse(url));
    }

    public record UploadResponse(String url) {}
}


