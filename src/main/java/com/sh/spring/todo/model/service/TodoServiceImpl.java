package com.sh.spring.todo.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sh.spring.todo.model.dao.TodoDao;
import com.sh.spring.todo.model.dto.Todo;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TodoServiceImpl implements TodoService {
	
	@Autowired
	private TodoDao todoDao;

	@Override
	public List<Todo> todoList() {
		log.debug("todoDao = {}",todoDao);
		return todoDao.todoList();
	}
	
	@Override
	public int insertTodo(Todo todo) {
		return todoDao.insertTodo(todo);
	}
	
	@Override
	public int updateTodo(Map<String, Object> param) {
		return todoDao.updateTodo(param);
	}
}
