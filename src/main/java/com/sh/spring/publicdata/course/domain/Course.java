package com.sh.spring.publicdata.course.domain;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Course {

	private long id;
	private String title;
	private int price;
	private LocalDate created;
	
	@JacksonXmlElementWrapper(useWrapping = true, localName = "students")
	@JacksonXmlProperty(localName = "student")
	private List<Student> students;
}
