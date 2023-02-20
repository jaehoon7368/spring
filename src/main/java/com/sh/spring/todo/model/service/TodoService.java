package com.sh.spring.todo.model.service;

import java.util.List;
import java.util.Map;

import com.sh.spring.todo.model.dto.Todo;

public interface TodoService {

	List<Todo> todoList();

	int insertTodo(Todo todo);

	int updateTodo(Map<String, Object> param);

}
