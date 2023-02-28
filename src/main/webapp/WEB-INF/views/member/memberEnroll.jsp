<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%--spring-webmvc가 제공하는 jstl - csrf 토큰 발행 --%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="회원등록" name="title"/>
</jsp:include>
<link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/member.css" />

<div id="enroll-container" class="mx-auto text-center">
	<form:form name="memberEnrollFrm" action="" method="POST">
		<table class="mx-auto w-100">
			<tr>
				<th>아이디</th>
				<td>
					<div id="memberId-container">
			            <input type="text" class="form-control" placeholder="아이디(4글자이상)" name="memberId" id="memberId" required>
			            <span class="guide ok">이 아이디는 사용가능합니다.</span>
			            <span class="guide error">이 아이디는 사용할 수 없습니다.</span>
			            <input type="hidden" id="idValid" value="0"/>
        			</div>
				</td>
			</tr>
			<tr>
				<th>패스워드</th>
				<td>
					<input type="password" class="form-control" name="password" id="password" required>
				</td>
			</tr>
			<tr>
				<th>패스워드확인</th>
				<td>	
					<input type="password" class="form-control" id="passwordCheck" required>
				</td>
			</tr>  
			<tr>
				<th>이름</th>
				<td>	
					<input type="text" class="form-control" name="name" id="name" required>
				</td>
			</tr>
			<tr>
				<th>생년월일</th>
				<td>	
					<input type="date" class="form-control" name="birthday" id="birthday"/>
				</td>
			</tr> 
			<tr>
				<th>이메일</th>
				<td>	
					<input type="email" class="form-control" placeholder="abc@xyz.com" name="email" id="email">
				</td>
			</tr>
			<tr>
				<th>휴대폰</th>
				<td>	
					<input type="tel" class="form-control" placeholder="(-없이)01012345678" name="phone" id="phone" maxlength="11" required>
				</td>
			</tr>
		</table>
		<input type="submit" value="가입" >
		<input type="reset" value="취소">
	</form:form>
</div>
<script>
const guides = document.querySelectorAll(".guide");
const ok = document.querySelector(".ok");
const error = document.querySelector(".error");
const idValid = document.querySelector("#idValid");
/**
 * 아이디가 4글자이상인 경우 server로 전송해서 사용가능여부를 표시한다.
 */
document.querySelector("#memberId").addEventListener("keyup",(e)=>{
	console.log(e.target.value);
	const memberId = e.target;
	if(memberId.value.length < 4){
		//초기화처리
		ok.style.display = "none";
		error.style.display = "none";
		idValid.value = 0;
		return;
	}

	
	$.ajax({
		url : "${pageContext.request.contextPath}/member/checkIdDuplicate3.do",
		data : {memberId : memberId.value},
		method : "GET",
		dataType : "json",
		success(data){
			console.log(data);
			const {memberId, available} = data;
			
			if(available){
				ok.style.display = "inline";
				error.style.display = "none";
				idValid.value = 1;
			}else{
				ok.style.display = "none";
				error.style.display = "inline";
				idValid.value = 0;
			}
		},
		error : console.log
	});
		
});

document.memberEnrollFrm.addEventListener('submit',(e) =>{
		if(idValid.value === '0'){
			e.preventDefault();
		}
});
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
