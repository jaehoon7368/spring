package com.sh.spring.board.model.dto;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.sh.spring.member.model.dto.Member;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@ToString(callSuper = true)
public class Board extends BoardEntity {

	private int attachCount; //첨부파일 개수
	private List<Attachment> attachments = new ArrayList<>();
	private Member member; //작성자 객체

	public Board(int no, String title, String memberId, String content, int readCount, LocalDateTime createdAt,
			int attachCount) {
		super(no, title, memberId, content, readCount, createdAt);
		this.attachCount = attachCount;
	}
	
	public void addAttachment(Attachment attach) {
		this.attachments.add(attach);
	}
	
}
