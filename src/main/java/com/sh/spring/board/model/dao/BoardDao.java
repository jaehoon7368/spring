package com.sh.spring.board.model.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import com.sh.spring.board.model.dto.Attachment;
import com.sh.spring.board.model.dto.Board;

@Mapper
public interface BoardDao {

	List<Board> selectAllBoard(RowBounds rowBounds);

	int insertBoard(Board board);

	int insertAttachment(Attachment attach);

}
