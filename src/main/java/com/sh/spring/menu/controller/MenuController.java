package com.sh.spring.menu.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sh.spring.menu.model.service.MenuService;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/menu")
@Slf4j
public class MenuController {

	@Autowired
	private MenuService menuService;
	
	@GetMapping("/menu.do")
	public void menu() {}
	
	@ResponseBody
	@GetMapping("/findMenuList.do")
	public ResponseEntity<?> findMenuList(){
		return menuService.findMenuList();
	}
	
	@PostMapping("/enrollMenu.do")
	public ResponseEntity<?> enrollMenu(@RequestBody Map<String,Object> menu){
		return menuService.enrollMenu(menu);
	}
}
