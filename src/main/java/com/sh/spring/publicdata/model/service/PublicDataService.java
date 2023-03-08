package com.sh.spring.publicdata.model.service;

import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;

public interface PublicDataService {

	ResponseEntity<?> getXmlCourseAsResource();

	ResponseEntity<?> getXmlCourseWithDocument();

	ResponseEntity<?> getXmlCourseWithObjectMapper();

	ResponseEntity<?> getXmlAirpollutionWirhObjectMapper(String sidoName);

	Resource getJsonCourseAsResource();

	Object getJsonCourseWithObjectMapper();

	Object getJsonAirpollutionWirhObjectMapper(String sidoName);

	Object getJsonPolicyWithObjectMapper();


}
