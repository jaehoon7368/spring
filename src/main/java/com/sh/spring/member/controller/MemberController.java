package com.sh.spring.member.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sh.spring.member.model.dto.Member;
import com.sh.spring.member.model.service.MemberService;

import lombok.extern.slf4j.Slf4j;

/**
 * Model이란?
 *  - view단에서 사용할 데이터를 임시로 보관하는 Map객체
 *  - viewName에 대한 처리도 포함할 수 있음.
 *  
 *  1. ModelAndView (일반클래스)
 *   - view단에 대한 정보가지고 있음. View객체 또는 viewName:String 작성가능
 *   - addObject 속성추가
 *   
 *  2. ModelMap(인터페이스)
 *   - view단 처리 별도.
 *   - addAttribute 속성추가
 *   
 *  3. Model
 *   - view단 처리 별도.
 *   - addAttribute 속성추가
 *   
 *  @ModelAttribute 또는 @SessionAttribute 어노테이션을 통해 저장된 속성 참조가능
 *  
 *  - ModelAndView와 RedirectAttributes는 함께 사용하지 말것.
 *
 */
@Slf4j
@Controller
@RequestMapping("/member")
@SessionAttributes({"loginMember"}) // 해당이름으로 model에 저장된 속성은 sessionScope에 저장
public class MemberController {
	
	//private static final Logger log = LoggerFactory.getLogger(MemberController.class);

	@Autowired
	private MemberService memberService;
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@GetMapping("/memberEnroll.do")
	public void memberEnroll() {} // /member/memberEnroll.do -> member/memberEnroll
	
	/**
	 * 메소드레벨의 @ModelAttribute는 사용시 요청시마다 호출되어, view단에 데이터를 전달할 수 있다.
	 * - 요청들간의 공용데이터 처리에 사용할 수 있다.
	 * - jsp에서 namespace. 속성명 형식으로 참조할 수 있다.
	 * @param model
	 * @return
	 */
//	@ModelAttribute("common")
//	public ModelMap common(ModelMap model) {
//		log.debug("MemberController#common 호출됨!");
//		model.addAttribute("email", "admin@shqke1.com");
//		model.addAttribute("tel", "070-123-4567");
//		return model;
//	}
	
	/**
	 * $2a$10$.85gA9ynsfoJdMM/JWdZxOrfQDW6Q.NDB6e9YlcNURWL5k552uyi2
	 * - 알고리즘 $2a$ , $2b$..
	 * - 옵션 10$ 이 값이 올라가면, 보다 복잡한 연산을 수행. 컴퓨팅 파워 요구
	 * - 랜덤솔트값 22자리 .85gA9ynsfoJdMM/JWdZxO
	 * - hash값 31자리 rfQDW6Q.NDB6e9YlcNURWL5k552uyi2
	 * 
	 * @param member
	 * @param redirectAttr
	 * @return
	 */
	@PostMapping("/memberEnroll.do")
	public String memberEnroll(Member member,RedirectAttributes redirectAttr) {
		try {
		log.debug("member = {}" , member);
		String rawPassword = member.getPassword();
		String encodedPassword = passwordEncoder.encode(rawPassword);
		member.setPassword(encodedPassword);
		log.debug("member = {}" , member);
		
		int result = memberService.insertMember(member);
		}catch(Exception e) {
			log.error("회원가입오류!",e);
			throw e;
		}
		log.trace("memberEnroll 끝!");
		return "redirect:/";
	}
	
	@GetMapping("/memberLogin.do")
	public String memberLogin() {
		return "member/memberLogin";
	}
	
//	@PostMapping("/memberLogin.do")
//	public String memberLogin(String memberId,String password, Model model, RedirectAttributes redirectAttr) {
//		log.debug("memberId = {}" , memberId);
//		log.debug("password = {}" , password);
//		
//		log.debug(passwordEncoder.encode(password));
//		
//		// 회원한명 조회
//		Member member = memberService.selectOneMember(memberId);
//		log.debug("member = {}" , member);
//		// 인증
//		// 1. 로그인 성공한 경우
//		if(member != null && passwordEncoder.matches(password, member.getPassword())) {
//			model.addAttribute("loginMember", member); //requestScope -> sessionScope
//		}
//		// 2. 로그인 실패한 경우(아이디/비번 불일치)
//		else {
//			redirectAttr.addFlashAttribute("msg", "사용자 아이디 또는 비밀번호가 일치하지 않습니다.");
//		}
//		
//		return "redirect:/";
//	}
	
	@PostMapping("/LoginSuccess.do")
	public String loginSuccess(HttpSession session) {
		log.debug("loginSuccess 핸들러 호출!");
		// 필요한 로그인 후처리
		String location = "/";
		
		// 시큐어리티가 지정한 리다이렉트 url 가져오기
		SavedRequest savedRequest = (SavedRequest)session.getAttribute("SPRING_SECURITY_SAVED_REQUEST");
		if(savedRequest != null)
				location = savedRequest.getRedirectUrl();
		
		log.debug("location = {}",location);
		
		return "redirect:" + location;
	}
	
	/**
	 * @SessionAttributes + mpdel을 통해 로그린 정보를 관리하는 경우,
	 * SessionStatus객체를 통해 사용완료처리해야 한다.
	 * - session객체를 폐기하지 않고 재사용.
	 * 
	 * @return
	 */
	@GetMapping("/memberLogout.do")
	public String memberLogout(SessionStatus status) {
		
		if(!status.isComplete())
			status.setComplete();	
		
		return "redirect:/";
	}
	
	/**
	 * security 인증객체 가져오기
	 */
	@GetMapping("/memberDetail.do")
	public void memberDetail(Authentication authentication) {
//		Authentication authenticagtion = SecurityContextHolder.getContext().getAuthentication();
		log.debug("authentication = {}",authentication);
		Member principal = (Member) authentication.getPrincipal();
		List<SimpleGrantedAuthority> authenities = (List<SimpleGrantedAuthority>)authentication.getAuthorities();
	}
	
	@PostMapping("/memberUpdate.do")
	public String memberUpdate(Member member,Authentication authentication) {
		log.debug("member = {}",member);
		// 1.db 변경
		int result = memberService.updateMember(member);
		// 2. security context의 인증객체 갱신
		Member newMember = memberService.selectOneMember(member.getMemberId());
//		Member newMember = member;
		Authentication newAuthenticaiton = new UsernamePasswordAuthenticationToken(
				newMember,
				authentication.getCredentials(),
				authentication.getAuthorities()
			);
		SecurityContextHolder.getContext().setAuthentication(newAuthenticaiton);
		
		return "redirect:/member/memberDetail.do";
	}
	
//	@PostMapping("/memberUpdate.do")
//	public String memberUpdate(RedirectAttributes redirectAttr, @ModelAttribute("loginMember")Member member ) {
//	
//		int result = memberService.updateMember(member);
//		
//		if(result > 0) {
//			redirectAttr.addFlashAttribute("msg", "회원정보를 성공적으로 수정하였습니다.");			
//		}else {
//			redirectAttr.addFlashAttribute("msg", "회원정보 수정이 실패했습니다.");
//		}
//		
//		return "redirect:/member/memberDetail.do";
//	}
	
	/**
	 * spring에서 json응답하기
	 * 1. jsonView빈 - model에 담긴 데이터를 json형식으로 변환후 응답메세지에 출력
	 * 2. @ResponseBody - Handler에서 반환된 map객체(dto)를 MessageConvertoer빈이 json변환후 응답메세지에 출력
	 * 3. ResponseEntity - @ResponseBody기능포함. 응답 staus code, 응답헤더, 응답메세지바디를 직접 작성하는 객체
	 * 						(MessageConvertoer빈이 json변환후) 
	 * 
	 * @param memberId
	 * @return
	 */
	@GetMapping("/checkIdDuplicate.do")
	public String checkIdDuplicate(@RequestParam String memberId, Model model) {
		log.debug("memberId = {}",memberId);
		Member member = memberService.selectOneMember(memberId);
		boolean available = member == null;
		
		model.addAttribute("memberId", memberId);
		model.addAttribute("available", available);
		
		return "jsonView";
	}
	
	@ResponseBody
	@GetMapping("/checkIdDuplicate2.do")
	public Map<String,Object> checkIdDuplicate2(@RequestParam String memberId) {
		Map<String,Object> map = new HashMap<>();
		Member member = memberService.selectOneMember(memberId);
		boolean available = member == null;
		
		map.put("memberId",memberId);
		map.put("available", available);
		
		return map;
	}
	
	/**
	 * - 응답코드
	 * - 응답헤더설정
	 * - 응답메세지바디
	 * 
	 * ResponseEntity 객체생성
	 * 1. new 연산자
	 * 2. builder 패텅
	 *  
	 * @param memberId
	 * @return
	 */
	@GetMapping("/checkIdDuplicate3.do")
	public ResponseEntity<Map<String,Object>> checkIdDuplicate3(@RequestParam String memberId) {
		Map<String,Object> map = new HashMap<>();
		Member member = memberService.selectOneMember(memberId);
		boolean available = member == null;
		map.put("memberId",memberId);
		map.put("available", available);
		map.put("hello", "world");
		
		
		
//		return ResponseEntity.ok(map); //200
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		
		return ResponseEntity
				.status(HttpStatus.OK)
				.headers(headers)
//				.header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_UTF8_VALUE)
				.body(map);
	}
}
