package com.sh.spring.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/admin")
public class AdminController {
	
	@GetMapping("/admin.do")
	public void admin() {
		log.debug("Admin 페이지 요청!");
	}
}
