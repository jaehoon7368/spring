package com.sh.spring.proxy;

public class ProxyMain {

	public static void main(String[] args) {

//		Foo foo = new FooImpl(); //스프링에서 @Autowired로 의존주입 받는 부분
//		Foo foo = new FooProxy(new FooImpl(),new Aspect());
//		String name = foo.bar("honggd");
//		System.out.println("name = " + name);
		
		// 대문자처리 proxy 만들기
//		Foo foo = new FooImpl(); // abcde -> ABCDE
		Foo foo = new FooProxy(new FooImpl(),new Aspect());
		String text = foo.getText();
		System.out.println("text = " + text);
	}

}
