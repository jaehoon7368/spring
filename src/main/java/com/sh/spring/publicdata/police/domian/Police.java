package com.sh.spring.publicdata.police.domian;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@lombok.Data
@NoArgsConstructor
@AllArgsConstructor
public class Police {

	private int page;
	private int perPage;
	private int totalCount;
	private int currentCount;
	private int matchCount;
	private List<Data> data;
}
