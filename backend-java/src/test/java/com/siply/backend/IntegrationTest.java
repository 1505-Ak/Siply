package com.siply.backend;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.siply.backend.auth.dto.LoginRequest;
import com.siply.backend.auth.dto.RegisterRequest;
import com.siply.backend.drinks.dto.DrinkRequest;
import com.siply.backend.drinks.DrinkRepository;
import com.siply.backend.users.UserRepository;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ExtendWith(SpringExtension.class)
@Testcontainers
class IntegrationTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine")
            .withDatabaseName("siply")
            .withUsername("postgres")
            .withPassword("postgres");

    @DynamicPropertySource
    static void datasourceProps(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DrinkRepository drinkRepository;

    @AfterEach
    void clean() throws Exception {
        drinkRepository.deleteAll();
        userRepository.deleteAll();
    }

    @Test
    void health_and_auth_and_drink_flow() throws Exception {
        mockMvc.perform(get("/health"))
                .andExpect(status().isOk());

        RegisterRequest register = new RegisterRequest("tester", "tester@example.com", "password123", "Tester");
        String registerJson = objectMapper.writeValueAsString(register);

        String registerResp = mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(registerJson))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        JsonNode registerNode = objectMapper.readTree(registerResp);
        String accessToken = registerNode.get("accessToken").asText();
        assertThat(accessToken).isNotBlank();

        LoginRequest login = new LoginRequest("tester", "password123");
        String loginJson = objectMapper.writeValueAsString(login);

        String loginResp = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(loginJson))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();

        JsonNode loginNode = objectMapper.readTree(loginResp);
        String authHeader = "Bearer " + loginNode.get("accessToken").asText();

        DrinkRequest drink = new DrinkRequest(
                "Cappuccino",
                "Coffee",
                null,
                null,
                null,
                "Cafe",
                "SF",
                "USA",
                null,
                null,
                null,
                null,
                false
        );

        String drinkJson = objectMapper.writeValueAsString(drink);

        mockMvc.perform(post("/api/drinks")
                        .header("Authorization", authHeader)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(drinkJson))
                .andExpect(status().isCreated());

        mockMvc.perform(get("/api/drinks"))
                .andExpect(status().isOk());
    }
}


