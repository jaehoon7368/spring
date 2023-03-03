package com.sh.spring.menu.model.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * GET - getForObject, getForEntity
 * POST - postForLocation, postForObject, postForEntity
 * PUT - put
 * PATCH - patchForObject
 * DELETE - delete
 * 
 * exchange - 모든 전송방식에 사용. ResponseEntity반환
 * @author jaehoon
 *
 */
@Service
public class MenuServiceImpl implements MenuService {

	private static final String MENU_URL = "http://localhost:10000/app/menu";
	
	@Override
	public ResponseEntity<?> findMenuList() {
		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));
		HttpEntity request = new HttpEntity(headers);
		
		return restTemplate.exchange(MENU_URL, HttpMethod.GET, request,List.class);
	}
	
	@Override
    public ResponseEntity<?> enrollMenu(Map<String, Object> menu) {
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        ObjectMapper objectMapper = new ObjectMapper(); // jackson-databind
        
        String json = null;
        try {
            json = objectMapper.writeValueAsString(menu);            
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        
        HttpEntity request = new HttpEntity(json, headers);
        return restTemplate.exchange(MENU_URL, HttpMethod.POST, request, Map.class);
    } // enrollMenu() end
}
