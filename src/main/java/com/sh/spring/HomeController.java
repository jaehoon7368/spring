package com.sh.spring;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import lombok.extern.slf4j.Slf4j;

/**
 * Handles requests for the application home page.
 */
@Controller
@Slf4j
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
//		System.out.println("homeeeeeeeeeeeeeeeeeee");
		return "forward:/index.jsp"; //forwarding경로 오버라이드(InternalResourceViewResolver 사용안함)
	}
	
	@GetMapping("/error/accessDenied.do")
	public void accessDenied() {
		log.debug("403 Forbiddeen");
	}
	
}
