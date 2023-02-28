package com.sh.spring.builder;

import java.time.LocalDate;

import lombok.ToString;

@ToString
public class User {

	private final String username; //필수
	private final String password; //필수
	private LocalDate birthday;
	private boolean married;
	
	public User(String username, String password, LocalDate birthday, boolean married) {
		super();
		this.username = username;
		this.password = password;
		this.birthday = birthday;
		this.married = married;
	}
	
	public static Builder builder(String username, String password) {
		return new Builder(username, password);
	}
	
	/**
	 * 빌더패턴을 위한 내부클래스
	 */
	public static class Builder {
		
		private final String username;
		private final String password;
		private LocalDate birthday;
		private boolean married;
		
		public Builder(String username, String password) {
			this.username = username;
			this.password = password;
		}
		
		public Builder birthday(LocalDate birthday) {
			this.birthday = birthday;
			return this;
		}
		public Builder married(boolean married) {
			this.married = married;
			return this;
		}
		public User build() {
			return new User(this.username,this.password,this.birthday,this.married);
		}
	}
}
