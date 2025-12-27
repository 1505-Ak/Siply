package com.siply.backend.media;

import org.springframework.web.multipart.MultipartFile;

public interface StorageService {
    String save(MultipartFile file);
}


