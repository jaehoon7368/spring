package com.sh.spring.member.model.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Member implements UserDetails {
	@NonNull
	private String memberId;
	@NonNull
	private String password;
	@NonNull
	private String name;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private LocalDate birthday; // 1999-09-09 사용자요청처리
	private String email;
	@NonNull
	private String phone;
	private LocalDateTime createdAt;
	private boolean enabled;
	
	/**
	 * 권한목록
	 * - 문자열 권한정보를 authority객체로 관리
	 */
	List<SimpleGrantedAuthority> authorities;
	
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return this.authorities;
	}
	@Override
	public String getUsername() {
		return this.memberId;
	}
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}
	@Override
	public boolean isAccountNonLocked() {
		return true;
	}
	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}
//	@Override
//	public boolean isEnabled() {
//		return true;
//	}
}
