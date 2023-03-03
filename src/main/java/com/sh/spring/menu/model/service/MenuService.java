package com.sh.spring.menu.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;

public interface MenuService {

	ResponseEntity<?> findMenuList();

	ResponseEntity<?> enrollMenu(Map<String, Object> menu);

}
