package com.sh.spring.common.aop;

import java.util.List;
import java.util.Map;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;

import com.sh.spring.todo.model.dto.Todo;

import lombok.extern.slf4j.Slf4j;

@Component
@Aspect
@Slf4j
public class EscapeXmlAspect {

	@Pointcut("execution(* com.sh.spring.todo.controller.TodoController.todoList(..))")
	public void pointcut() {}
	
	@AfterReturning(pointcut = "pointcut()", returning = "returnObj")
	public void escapeXml(JoinPoint joinPoint, Object returnObj) {
		log.debug("returnObj = {}",returnObj);
		ModelAndView mav = (ModelAndView) returnObj;
		Map<String,Object> model = mav.getModel();
		List<Todo> todoList = (List<Todo>) model.get("todoList");
		
		for(Todo todo : todoList) {
			String maybeXss = todo.getTodo();
			todo.setTodo(escapeXml(maybeXss));
		}
	}
	
	private String escapeXml(String maybeXss) {
		return maybeXss.replaceAll("<", "&lt")
				.replaceAll(">", "&gt");
	}
}
