package com.sh.spring.publicdata.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sh.spring.publicdata.model.service.PublicDataService;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/publicData")
@Slf4j
public class PublicDataController {

	@Autowired
	private PublicDataService publicDataService;
	
	@GetMapping("/publicData.do")
	public void publicData() {}
	
	/**
	 * 1.Resource 전달받은 xml을 그대로 client에 전달 - client에서 js로 xml처리
	 * 2.전달받은 xml을 먼저 java로 변환후 선처리, 이후 client에 다시 전달
	 * 	- 데이터 미리 가공
	 * 	- 데이터 db 저장 
	 */
	@GetMapping("/xml/course.do")
	public ResponseEntity<?> xmlCourse(){
//		return publicDataService.getXmlCourseAsResource();
//		return publicDataService.getXmlCourseWithDocument();
		return publicDataService.getXmlCourseWithObjectMapper();
	}
	
	@GetMapping("/xml/airpollution.do")
	public ResponseEntity<?> xmlAirpollution(){
		return publicDataService.getXmlAirpollutionWirhObjectMapper();
	}
	
	@GetMapping("/xml/airpollutionChange.do")
	public ResponseEntity<?> xmlAirpollutionChange(@RequestParam String sidoName){
		return publicDataService.getXmlAirpollutionWithObjectMapperChange(sidoName);
	}
}
