package com.sh.spring.member.model.service;

import com.sh.spring.member.model.dto.Member;

public interface MemberService {

	int insertMember(Member member);

	Member selectOneMember(String memberId);

	int updateMember(Member member);

}
