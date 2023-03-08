package com.sh.spring.publicdata.airpollution.domain;

import java.util.List;

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper;
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Body {
	@JacksonXmlElementWrapper(localName="items")
	@JacksonXmlProperty(localName="item")
	private List<Item> items;
	private int numOfRows;
	private int pageNo;
	private int totalCount;
}