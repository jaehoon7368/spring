package com.sh.spring.board.model.service;

import java.util.List;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sh.spring.board.model.dao.BoardDao;
import com.sh.spring.board.model.dto.Attachment;
import com.sh.spring.board.model.dto.Board;

import lombok.extern.slf4j.Slf4j;

@Transactional(rollbackFor = Exception.class)//발셍하는 모든 예외에 대해 rollback 처리
@Service
@Slf4j
public class BoardServiceImpl implements BoardService {

	@Autowired
	private BoardDao boardDao;
	
	@Override
	public List<Board> selectAllBoard(RowBounds rowBounds) {
		return boardDao.selectAllBoard(rowBounds);
	}
	
	/**
	 * 1건의 board 등록
	 * n건의 attachment 등록
	 */
//	@Transactional(rollbackFor = Exception.class) //발셍하는 모든 예외에 대해 rollback 처리
	@Override
	public int insertBoard(Board board) {
		// 게시글 등록 - 동시에 채번된 pk를 조회
		int result = boardDao.insertBoard(board);
		log.debug("board = {}",board);
		
		//첨부파일 등록
		List<Attachment> attachments = board.getAttachments();
		if(attachments.size() >0) {
			for(Attachment attach : attachments) {
				attach.setBoardNo(board.getNo()); //fk설정
				result = insertAttachment(attach);
			}
		}
		
		return result;
	}
	
	@Override
	public int insertAttachment(Attachment attach) {
		return boardDao.insertAttachment(attach);
	}
}
