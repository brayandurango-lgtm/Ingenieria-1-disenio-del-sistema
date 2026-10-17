package com.autoscolombia.integration;

import com.autoscolombia.domain.enums.EstadoCelda;
import com.autoscolombia.domain.enums.TipoUsuario;
import com.autoscolombia.domain.enums.TipoVehiculo;
import com.autoscolombia.domain.model.Celda;
import com.autoscolombia.domain.model.Usuario;
import com.autoscolombia.infrastructure.repository.AuditoriaLogRepository;
import com.autoscolombia.infrastructure.repository.CeldaRepository;
import com.autoscolombia.infrastructure.repository.ComprobanteRepository;
import com.autoscolombia.infrastructure.repository.NovedadRepository;
import com.autoscolombia.infrastructure.repository.RegistroRepository;
import com.autoscolombia.infrastructure.repository.UsuarioRepository;
import com.autoscolombia.infrastructure.repository.VehiculoRepository;
import com.autoscolombia.presentation.dto.LoginRequest;
import com.autoscolombia.presentation.dto.RegistroEntradaDTO;
import com.autoscolombia.presentation.dto.RegistroSalidaDTO;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class RegistroControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private CeldaRepository celdaRepository;

    @Autowired
    private RegistroRepository registroRepository;

    @Autowired
    private ComprobanteRepository comprobanteRepository;

    @Autowired
    private AuditoriaLogRepository auditoriaLogRepository;

    @Autowired
    private NovedadRepository novedadRepository;

    @Autowired
    private VehiculoRepository vehiculoRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private ObjectMapper objectMapper;

    private String token;
    private Usuario usuario;

    @BeforeEach
    void setUp() throws Exception {
        comprobanteRepository.deleteAll();
        novedadRepository.deleteAll();
        registroRepository.deleteAll();
        auditoriaLogRepository.deleteAll();
        celdaRepository.deleteAll();
        vehiculoRepository.deleteAll();
        usuarioRepository.deleteAll();

        Celda celda = Celda.builder()
                .numero("A-01")
                .piso(1)
                .tipoVehiculo(TipoVehiculo.CARRO)
                .estado(EstadoCelda.DISPONIBLE)
                .build();
        celdaRepository.save(celda);

        usuario = Usuario.builder()
                .nombre("Test")
                .apellido("User")
                .documento("12345678")
                .correo("test@test.com")
                .claveHash(passwordEncoder.encode("clave123"))
                .tipo(TipoUsuario.OPERADOR)
                .activo(true)
                .build();

        usuarioRepository.save(usuario);

        // Login para obtener token
        LoginRequest loginRequest = LoginRequest.builder()
                .correo("test@test.com")
                .clave("clave123")
                .build();

        String response = mockMvc.perform(post("/api/v1/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();

        token = objectMapper.readTree(response).get("token").asText();
    }

    @Test
    void testRegistrarEntrada_Exito() throws Exception {
        RegistroEntradaDTO entradaDTO = RegistroEntradaDTO.builder()
                .placa("XYZ987")
                .marca("Mazda")
                .modelo("3")
                .color("Azul")
                .tipo(TipoVehiculo.CARRO)
                .propietarioDocumento("87654321")
                .propietarioNombre("Pedro Gómez")
                .propietarioTelefono("3009876543")
                .build();

        mockMvc.perform(post("/api/v1/registros/entrada")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(entradaDTO)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.placa").value("XYZ987"))
                .andExpect(jsonPath("$.estado").value("ACTIVO"));
    }

    @Test
    void testRegistrarEntrada_SinToken_401() throws Exception {
        RegistroEntradaDTO entradaDTO = RegistroEntradaDTO.builder()
                .placa("XYZ987")
                .marca("Mazda")
                .modelo("3")
                .color("Azul")
                .tipo(TipoVehiculo.CARRO)
                .build();

        mockMvc.perform(post("/api/v1/registros/entrada")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(entradaDTO)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void testListarActivos_Exito() throws Exception {
        mockMvc.perform(get("/api/v1/registros/activos")
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }

    @Test
    void testListarUltimosIngresos_Exito() throws Exception {
        mockMvc.perform(get("/api/v1/registros/ultimos?limite=5")
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
    }
}
