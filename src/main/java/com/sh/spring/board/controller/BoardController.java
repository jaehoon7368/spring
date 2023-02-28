package com.sh.spring.board.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sh.spring.board.model.dto.Attachment;
import com.sh.spring.board.model.dto.Board;
import com.sh.spring.board.model.service.BoardService;
import com.sh.spring.common.HelloSpringUtils;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/board")
@Slf4j
public class BoardController {

	@Autowired
	private BoardService boardService;
	
	@Autowired
	private ServletContext application;
	
	@Autowired
	private ResourceLoader resourceLoader;
	
	@GetMapping("/boardList.do")
	public void boardList(@RequestParam(defaultValue = "1")int cpage,Model model) {
		//페이징 RowBounds
		int limit = 10; //한페이지당 조회할 게시글 수
		int offset = (cpage -1) * limit; //cpage=1, offset=0 | cpage=2 , offset=10 | cpage=3, offset=20| ..
		RowBounds rowBounds = new RowBounds(offset,limit);
		
		List<Board> boardList = boardService.selectAllBoard(rowBounds);
		log.debug("boardList = {}",boardList );
		model.addAttribute("boardList", boardList);
	}
	
	@GetMapping("/boardForm.do")
	public void boardForm() {}
	
	@PostMapping("/boardEnroll.do")
	public String boardEnroll(
			Board board,
			@RequestParam("upFile") List<MultipartFile> upFiles,
			RedirectAttributes redirectAttr) {
		log.debug("board={}",board);
		
		//ServletContext : application갹체의 타입. DI. 스프링과 관계없는 servlet spec의 객체
		String saveDirectory = application.getRealPath("/resources/upload/board");
		log.debug("saveDirectory = {}",saveDirectory );
		// 첨부파일 저장(서버컴퓨터) 및 Attachment객체 만들기
		for(MultipartFile upFile : upFiles) {
			log.debug("upFile = {}",upFile);
//			log.debug("upFile = {}",upFile.getOriginalFilename());
//			log.debug("upFile = {}",upFile.getSize());
			
			if(upFile.getSize() > 0) {
				// 1. 저장 
				String renamedFilename = HelloSpringUtils.renameMutipartFile(upFile);
				String originalFilename = upFile.getOriginalFilename();
				File destFile = new File(saveDirectory,renamedFilename);
				try {
					upFile.transferTo(destFile);
				} catch (IllegalStateException | IOException e) {
					log.error(e.getMessage(),e);
				}
				
				// 2. attach객체생성 및 Board추가
				Attachment attach = new Attachment();
				attach.setRenamedFilename(renamedFilename);
				attach.setOriginalFilename(originalFilename);
				board.addAttachment(attach);
			}
			
		}
		
		log.debug("board ={}",board);
		int result = boardService.insertBoard(board);
		
		redirectAttr.addFlashAttribute("msg","게시글을 성공적으로 저장했습니다.");
		
		return "redirect:/board/boardList.do";
	}
	
	@GetMapping("/boardDetail.do")
	public void boardDetail(@RequestParam int no,Model model) {
		log.debug("no = {}",no);
//		Board board = boardService.selectOneBoard(no);
		Board board = boardService.selectOneBoardCollection(no);
		
		model.addAttribute("board", board);
	}
	
	/**
	 * Resource 인터페이스
	 * 직접 아래 구현클래스를 객체화할수도, path 경로값을 이용해서 자동지정할 수도 있다.
	 * - UrlResource 인터넷상의 파일
	 * - ClassPathResource classpath의 파일
	 * - FileUrlResource | FileSystemResource 서버컴퓨터의 파일
	 * - ServletContextResource 웹루트디렉토리의 파일
	 * - ByteArrayResource 이진데이터
	 * - ...
	 * 
	 * @ResponseBody
	 *  - 핸들러의 반환객체를 응답메세지 바디에 직접 출력
	 *  
	 *  이진데이터용 MessageConverter빈이 직접출력
	 * 
	 * @param no
	 * @return
	 */
	@ResponseBody
	@GetMapping("/fileDownload.do")
	public Resource fileDownload(@RequestParam int no, HttpServletResponse response) {
		// renamedFilename 파일을 찾고, originalFilename으로 파일명 전송.
		Attachment attach = boardService.selectOneAttachment(no);
		log.debug("attach = {}",attach);
		
		//FileSystemResource - file: ~경로 사용
		String renamedFilename = attach.getRenamedFilename();
		String originalFilename = attach.getOriginalFilename();
		//한글꺠짐대비
		try {
			originalFilename = new String(originalFilename.getBytes("utf-8"),"iso-8859-1");//톰켓기본인코딩 변환처리
		} catch (UnsupportedEncodingException e) {
			log.error(e.getMessage(),e);
		}
		
		String saveDirectory = application.getRealPath("/resources/upload/board");
		File downFile = new File(saveDirectory,renamedFilename);
		
		String location = "file:" + downFile; //downFile의 절대경로
		Resource resource = resourceLoader.getResource(location);
		log.debug("resource = {}",resource);
		log.debug("resource.exists() ={}",resource.exists());
		log.debug("resource.getClass() ={}",resource.getClass());
		
		
		//응답헤더설정
		response.setContentType("application/octet-stream; charset=utf-8");
		response.addHeader("Content-Disposition", "attachment; filename =" + originalFilename);
		return resource;
	}
}
