package com.sh.spring.publicdata.model.service;

import org.springframework.http.ResponseEntity;

public interface PublicDataService {

	ResponseEntity<?> getXmlCourseAsResource();

	ResponseEntity<?> getXmlCourseWithDocument();

	ResponseEntity<?> getXmlCourseWithObjectMapper();

	ResponseEntity<?> getXmlAirpollutionWirhObjectMapper();

	ResponseEntity<?> getXmlAirpollutionWithObjectMapperChange(String sidoName);

}
