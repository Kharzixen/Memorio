package com.kharzixen.authenticationservice.service;


import com.kharzixen.authenticationservice.model.User;
import com.kharzixen.authenticationservice.repository.UserRepository;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;

@Component
@RequiredArgsConstructor
public class JwtUtil {
    @Value("${jwt.secret}")
    private String secret;

    private final UserRepository userRepository;


    public boolean validateAccessToken(String token) {
        try {
            Claims claims = Jwts.parserBuilder().setSigningKey(getSignKey()).build().parseClaimsJws(token).getBody();
            return Objects.equals(claims.get("type").toString(), "accessToken");
        } catch (Exception e) {
            return false;
        }
    }

    public boolean validateRefreshToken(String token) {
        try {
            Claims claims = Jwts.parserBuilder().setSigningKey(getSignKey()).build().parseClaimsJws(token).getBody();
            return Objects.equals(claims.get("type").toString(), "refreshToken");
        } catch (Exception e) {
            return false;
        }
    }


    public String generateAccessToken(String username) {
        Map<String, Object> claims = new HashMap<>();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        claims.put("id", user.getId());
        claims.put("type", "accessToken");
        Date expirationDate = new Date(System.currentTimeMillis() + 1000 * 60*60);
        return createToken(claims, username, expirationDate);
    }

    public String generateRefreshToken(String username) {
        Map<String, Object> claims = new HashMap<>();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        claims.put("id", user.getId());
        claims.put("type", "refreshToken");
        Date expirationDate = new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24);
        return createToken(claims, username, expirationDate);
    }


    private String createToken(Map<String, Object> claims, String userName, Date expirationDate) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(userName)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(expirationDate)
                .signWith(getSignKey(), SignatureAlgorithm.HS256).compact();
    }

    private Key getSignKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secret);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    // Method to extract the username from a token
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    // Method to extract all claims from a token
    private Claims extractAllClaims(String token) {
        return Jwts.parserBuilder().setSigningKey(getSignKey()).build().parseClaimsJws(token).getBody();
    }

}
