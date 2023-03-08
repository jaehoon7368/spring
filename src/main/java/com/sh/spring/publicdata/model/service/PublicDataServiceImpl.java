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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
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
import com.sh.spring.publicdata.airpollution.domain.Wrapper;
import com.sh.spring.publicdata.course.domain.Course;
import com.sh.spring.publicdata.course.domain.Student;
import com.sh.spring.publicdata.police.domian.Police;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@PropertySource("classpath:conf.properties")
public class PublicDataServiceImpl implements PublicDataService {

//	public static final String XML_COURSE_URL = "https://shqkel.github.io/course.xml";
//	public static final String JSON_COURSE_URL = "https://shqkel.github.io/course.json";
//	public static final String AIRPOLLUTION_URL = "https://api.odcloud.kr/api/RltmArpltnInforInqireSvrc/v1/getCtprvnRltmMesureDnsty";
//	public static final String AIRPOLLUTION_SERVICE_KEY = "4hJcvIAdbdbIuivwddYDiWkY2YR+DYF+SZfVPTGRMB7vswenI/vOBKLGOCJedAUXXhR14LiKx2QmyKAuBBZXSg==";
	
	@Value("${XML_COURSE_URL}")
	public String XML_COURSE_URL;
	@Value("${JSON_COURSE_URL}")
	public String JSON_COURSE_URL;
	@Value("${AIRPOLLUTION_URL}")
	public String AIRPOLLUTION_URL;
	@Value("${AIRPOLLUTION_SERVICE_KEY}")
	public String AIRPOLLUTION_SERVICE_KEY;
	@Value("${POLICY_URL}")
	public String POLICY_URL;
	@Value("${POLICY_SERVICE_KEY}")
	public String POLICY_SERVICE_KEY;
	
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
		return ResponseEntity.ok(readValue(XML_COURSE_URL, Course.class)); //contentType xml생략가능 (jackson-dataformat-xml 의존)
	}
	
	/**
	 * 제네릭클래스
	 *  - 클래스레벨에서 타입변수를 선언하고, 객체 생성시점에 타입을 결정
	 *  - List<String> list = new ArrayList<>();
	 * 
	 * 제네릭메소드
	 *  - 메소드레벨에서 타입변수를 선언하고, 메소드 호출시점에 타입을 결정
	 *  - readValue("http://~", Course.class);
	 */
	public <T> T readValue(String url, Class<T> clazz) {
		ObjectMapper om = new XmlMapper().registerModule(new JavaTimeModule()); //time 패키지 사용하는 경우
		T result = null;
		try {
			result = om.readValue(new URL(url),clazz);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result; 
	}
	
	@Override
	public ResponseEntity<?> getXmlAirpollutionWirhObjectMapper(String sidoName) {
		String url = AIRPOLLUTION_URL;
		try {
			url += "?sidoName=" + URLEncoder.encode(sidoName, "utf-8");
			url += "&serviceKey=" + URLEncoder.encode(AIRPOLLUTION_SERVICE_KEY, "utf-8");
			log.debug("url = {}",url);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return ResponseEntity.ok(readValue(url,Response.class));
	}
	
	@Override
	public Resource getJsonCourseAsResource() {
		return resourceLoader.getResource(JSON_COURSE_URL);
	}
	
	@Override
	public Object getJsonCourseWithObjectMapper() {
		ObjectMapper om = new ObjectMapper().registerModule(new JavaTimeModule());
		Course course = null;
		try {
			course = om.readValue(new URL(JSON_COURSE_URL), Course.class);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return course;
	}
	
	@Override
	public Object getJsonAirpollutionWirhObjectMapper(String sidoName) {
		String url = AIRPOLLUTION_URL;
		try {
			url += "?sidoName=" + URLEncoder.encode(sidoName,"utf-8");
			url += "&serviceKey=" + URLEncoder.encode(AIRPOLLUTION_SERVICE_KEY,"utf-8");
			url += "&returnType=json"; 
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		ObjectMapper om = new ObjectMapper().registerModule(new JavaTimeModule());
		Wrapper wrapper = null;
		try {
			wrapper = om.readValue(new URL(url), Wrapper.class); //{"header":.., "body":..}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return wrapper;
	}
	
	@Override
	public Object getJsonPolicyWithObjectMapper() {
		String url = POLICY_URL;
		try {
			url += "?page=1&perPage=10";
			url += "&serviceKey=" + URLEncoder.encode(POLICY_SERVICE_KEY,"utf-8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		ObjectMapper om = new ObjectMapper();
		Police police = null;
		try {
			police = om.readValue(new URL(url), Police.class); //{"header":.., "body":..}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return police;
	}
}
