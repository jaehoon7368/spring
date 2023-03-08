package com.sh.spring.publicdata.model.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.sh.spring.publicdata.airpollution.domain.Response;
import com.sh.spring.publicdata.course.domain.Course;
import com.sh.spring.publicdata.course.domain.Student;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class PublicDataServiceImpl implements PublicDataService {

	public static final String XML_COURSE_URL = "https://shqkel.github.io/course.xml";
	public static final String AIRPOLLUTION_URL = "https://api.odcloud.kr/api/RltmArpltnInforInqireSvrc/v1/getCtprvnRltmMesureDnsty";
	public static final String AIRPOLLUTION_SERVICE_KEY = "4hJcvIAdbdbIuivwddYDiWkY2YR+DYF+SZfVPTGRMB7vswenI/vOBKLGOCJedAUXXhR14LiKx2QmyKAuBBZXSg==";
	
	@Autowired
	private ResourceLoader resourceLoader;
	
	@Override
	public ResponseEntity<?> getXmlCourseAsResource() {
		Resource resource = resourceLoader.getResource(XML_COURSE_URL);
		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_TYPE, MediaType.TEXT_XML_VALUE) //json(기본값)이 아닌 xml설정
				.body(resource);
	}
	
	@Override
	public ResponseEntity<?> getXmlCourseWithDocument() {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder;
		Course course = null;
		try {
			builder = factory.newDocumentBuilder();
			Document doc =  builder.parse(XML_COURSE_URL);
			//정규화 : textNode정리 <tag> textNode textNode </tag> ----> <tag>textNode</tag>
			doc.normalize();
			
			long id = Long.parseLong(doc.getElementsByTagName("id").item(0).getTextContent());
			String title = doc.getElementsByTagName("title").item(0).getTextContent();
			int price = Integer.parseInt(doc.getElementsByTagName("price").item(0).getTextContent());
			LocalDate created = LocalDate.parse(doc.getElementsByTagName("created").item(0).getTextContent());
			//yyyy-MM-dd
			
			NodeList nodeList =  doc.getElementsByTagName("student"); //Element상위타입
			List<Student> students = new ArrayList<>();
			for(int i = 0; i < nodeList.getLength();i++) {
				Node node = nodeList.item(i);
				Element elem = (Element) node;
				long _id = Long.parseLong(elem.getElementsByTagName("id").item(0).getTextContent());
				String name = elem.getElementsByTagName("name").item(0).getTextContent();
				String tel = elem.getElementsByTagName("tel").item(0).getTextContent();
				Student student = new Student(_id,name,tel);
				students.add(student);
			}
			
			course = new Course();
			course.setId(id);
			course.setTitle(title);
			course.setPrice(price);
			course.setCreated(created);
			course.setStudents(students);
			
		} catch (ParserConfigurationException |SAXException | IOException e) {
			e.printStackTrace();
		}
		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_TYPE, MediaType.TEXT_XML_VALUE)
				.body(course);
	}
	
	@Override
	public ResponseEntity<?> getXmlCourseWithObjectMapper() {
		ObjectMapper om = new XmlMapper().registerModule(new JavaTimeModule()); //time 패키지 사용하는 경우
		Course course = null;
		try {
			course = om.readValue(new URL(XML_COURSE_URL),Course.class);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return ResponseEntity.ok(course); //contentType xml생략가능 (jackson-dataformat-xml 의존)
	}
	
	@Override
	public ResponseEntity<?> getXmlAirpollutionWirhObjectMapper() {
		ObjectMapper om = new XmlMapper();
		Response response = null;
		String url = AIRPOLLUTION_URL;
		try {
			url += "?sidoName=" + URLEncoder.encode("서울", "utf-8");
			url += "&serviceKey=" + URLEncoder.encode(AIRPOLLUTION_SERVICE_KEY, "utf-8");
			log.debug("url = {}",url);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		try {
			response = om.readValue(new URL(url), Response.class);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return ResponseEntity.ok(response);
	}
	
	@Override
	public ResponseEntity<?> getXmlAirpollutionWithObjectMapperChange(String sidoName) {
		ObjectMapper om = new XmlMapper();
		Response response = null;
		String url = AIRPOLLUTION_URL;
		try {
			url += "?sidoName=" + URLEncoder.encode(sidoName, "utf-8");
			url += "&serviceKey=" + URLEncoder.encode(AIRPOLLUTION_SERVICE_KEY, "utf-8");
			log.debug("url = {}",url);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		try {
			response = om.readValue(new URL(url), Response.class);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return ResponseEntity.ok(response);
	}
}
