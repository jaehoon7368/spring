package com.sh.spring.builder;

import java.time.LocalDate;

public class UserMain {

	public static void main(String[] args) {
		// 객체 생성하는 방법
		// 1. 기본생성자 + setter
		// 2. 파라미터생성자
		// 3. builder
		
//		User user = 
//				User.builder()
//					.username("honggd")
//					.password("1234")
////					.birthday(LocalDate.of(1999, 9, 9))
////					.married(true)
//					.build();
		
		User user = User.builder("sinsa", "1234")
						.birthday(LocalDate.of(1988, 8, 8))
						.build();
		
		System.out.println(user);
	}

}
