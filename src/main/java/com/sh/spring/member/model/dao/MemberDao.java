package com.sh.spring.member.model.dao;

import org.apache.ibatis.annotations.Mapper;

import com.sh.spring.member.model.dto.Member;

@Mapper
public interface MemberDao {

	int insertMember(Member member);

}
