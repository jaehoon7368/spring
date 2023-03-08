package com.sh.spring.publicdata.airpollution.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Header {
	private String resultCode;
	private String resultMsg;
}
