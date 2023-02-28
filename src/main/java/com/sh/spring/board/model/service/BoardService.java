package com.sh.spring.board.model.service;

import java.util.List;

import org.apache.ibatis.session.RowBounds;

import com.sh.spring.board.model.dto.Attachment;
import com.sh.spring.board.model.dto.Board;

public interface BoardService {

	List<Board> selectAllBoard(RowBounds rowBounds);

	int insertBoard(Board board);
	
	int insertAttachment(Attachment attach);

	Board selectOneBoard(int no);

	Board selectOneBoardCollection(int no);

	Attachment selectOneAttachment(int no);


}
