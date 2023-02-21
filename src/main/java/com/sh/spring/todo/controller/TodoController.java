package com.sh.spring.todo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sh.spring.todo.model.dto.Todo;
import com.sh.spring.todo.model.service.TodoService;

import lombok.extern.slf4j.Slf4j;

/**
 * aop의 작동원리
 * - DI받은 객체는 우리가 만든 클레스베이스의 객체가 아닌 스프링이 의도한 proxy객체이다.
 * - 인터페이스 구현객체인 경우, jdk동적 proxy에서 생성한 객체가 주입
 * - 인터페이스 구현클레스가 아닌 경우, cglib패키지에서 제공된 객체가 주입.
 */

@Controller
@Slf4j
@RequestMapping("/todo")
public class TodoController {
	
	@Autowired
	private TodoService todoService;
	
	@GetMapping("/todoList.do")
	public ModelAndView todoList(ModelAndView mav) {
		log.debug("todoService = {}",todoService.getClass());
		List<Todo> todoList = todoService.todoList();
		log.debug("todoList = " + todoList);
		mav.addObject("todoList", todoList);
		mav.setViewName("todo/todoList");
		
		return mav;
	}
	
	/**
	 * insert into todo values (seq_todo_no.nextval, ? , default, default)
	 * @param todo
	 * @param redirectAttr
	 * @return
	 */
	@PostMapping("/insertTodo.do")
	public String insertTodo(Todo todo,RedirectAttributes redirectAttr) {
		log.debug("todo= {}" , todo);
		int result = todoService.insertTodo(todo);
		redirectAttr.addFlashAttribute("msg", "할일을 성공적으로 등록했습니다.");
		return "redirect:/todo/todoList.do";
	}
	
	@PostMapping("/updateTodo.do")
	public String updateTodo(
			@RequestParam int no,
			@RequestParam boolean isCompleted) {
		Map<String, Object> param = new HashMap<>();
		param.put("no", no);
		param.put("isCompleted", isCompleted);
		log.debug("param = {}", param);
		
		int result = todoService.updateTodo(param);
		
		return "redirect:/todo/todoList.do";
	}
}
