<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:requestEncoding value="utf-8"/>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param name="title" value="공공데이터활용" />
</jsp:include>
	<div id="data-container" class="w-75 mx-auto">
		<h2>course - xml</h2>
		<button class="btn btn-block btn-outline-primary" id="btn-course-xml">확인</button>
		<div id="course-xml-wrapper">
			<table class="table" id="tbl-xml-course">
				<tbody>
					<tr>
						<th>번호</th>
						<td class="id"></td>
					</tr>
					<tr>
						<th>수업명</th>
						<td class="title"></td>
					</tr>
					<tr>
						<th>수강료</th>
						<td class="price"></td>
					</tr>
					<tr>
						<th>개설일</th>
						<td class="created"></td>
					</tr>
				</tbody>
			</table>
			
			<table class="table" id="tbl-xml-studnet">
				<thead>
					<tr>
						<th>아이디</th>
						<th>이름</th>
						<th>전화번호</th>
					</tr>
				</thead>
				<tbody id="tbl-xml-studnet-tbody"></tbody>
			</table>
		</div>
		<script>
		document.querySelector("#btn-course-xml").addEventListener('click',(e)=>{
			$.ajax({
				url : '${pageContext.request.contextPath}/publicData/xml/course.do',
				success(doc){
					console.log(doc); //xml document
					const tblCourse = document.querySelector("#tbl-xml-course");
					const id = doc.querySelector("id");
					const title = doc.querySelector("title");
					const price = doc.querySelector("price");
					const created = doc.querySelector("created");
					tblCourse.querySelector(".id").innerHTML = id.textContent;
					tblCourse.querySelector(".title").innerHTML = title.textContent;
					tblCourse.querySelector(".price").innerHTML = price.textContent;
					tblCourse.querySelector(".created").innerHTML = created.textContent;
					
					//@실습문제 : studnet데이터 렌더링
					const students = doc.querySelectorAll("student");
					const tbody = document.querySelector("#tbl-xml-studnet-tbody");
					tbody.innerHTML ="";
					
					students.forEach((student)=>{
						const [id,name,tel] = student.children;
						tbody.innerHTML += `
							<tr>
								<td>\${id.textContent}</td>
								<td>\${name.textContent}</td>
								<td>\${tel.textContent}</td>
							</tr>
						`;
					});
				},
				error: console.log
			});
		});
		</script>
		
		<h2>대기오염 - xml</h2>
		<button class="btn btn-block btn-outline-primary" id="btn-airpollution-xml">확인</button>
		<select name="sidoName" id="sidoName">
			<option value="서울">서울</option>
			<option value="부산">부산</option>
			<option value="대구">대구</option>
			<option value="인천">인천</option>
			<option value="광주">광주</option>
			<option value="대전">대전</option>
			<option value="울산">울산</option>
			<option value="경기">경기</option>
			<option value="강원">강원</option>
			<option value="충북">충북</option>
			<option value="충남">충남</option>
			<option value="전북">전북</option>
			<option value="전남">전남</option>
			<option value="경북">경북</option>
			<option value="경남">경남</option>
			<option value="제주">제주</option>
			<option value="세종">세종</option>
		</select>
		<div id="airpollution-xml-mapper">
		<table class="table" id="tbl-xml-airpollution">
				<tbody>
					<tr>
						<th>결과코드</th>
						<td class="resultCode"></td>
					</tr>
					<tr>
						<th>결과메세지</th>
						<td class="resultMsg"></td>
					</tr>
					<tr>
						<th>한페이지 결과 수</th>
						<td class="numOfRows"></td>
					</tr>
					<tr>
						<th>페이지 번호</th>
						<td class="pageNo"></td>
					</tr>
					<tr>
						<th>전체 결과 수</th>
						<td class="totalCount"></td>
					</tr>
				</tbody>
			</table>
			
			<table class="table" id="tbl-xml-item">
				<thead>
					<tr>
						<th>No</th>
						<th>지역</th>
						<th>측정소</th>
						<th>이황산가스</th>
						<th>일산화탄소</th>
						<th>오존</th>
						<th>이산화질소</th>
						<th>미세먼지(PM10)</th>
						<th>미세먼지(PM2.5)</th>
						<th>통합대기환경</th>
					</tr>
				</thead>
				<tbody id="tbl-xml-item-tbody"></tbody>
			</table>
		
		</div>
		<script>
		document.querySelector("#btn-airpollution-xml").addEventListener('click',(e)=>{
			$.ajax({
				url : "${pageContext.request.contextPath}/publicData/xml/airpollution.do",
				success(doc){
					console.log(doc);
					const tblAirpollution = document.querySelector("#tbl-xml-airpollution");
					const resultCode = doc.querySelector("resultCode");
					const resultMsg = doc.querySelector("resultMsg");
					const numOfRows = doc.querySelector("numOfRows");
					const pageNo = doc.querySelector("pageNo");
					const totalCount = doc.querySelector("totalCount");
					tblAirpollution.querySelector(".resultCode").innerHTML = resultCode.textContent;
					tblAirpollution.querySelector(".resultMsg").innerHTML = resultMsg.textContent;
					tblAirpollution.querySelector(".numOfRows").innerHTML = numOfRows.textContent;
					tblAirpollution.querySelector(".pageNo").innerHTML = pageNo.textContent;
					tblAirpollution.querySelector(".totalCount").innerHTML = totalCount.textContent;
					
					const item = doc.querySelectorAll("item");
					const tbody = document.querySelector("#tbl-xml-item-tbody");
					tbody.innerHTML = "";
					
					item.forEach((item, index) => {
						console.log(item);
						const sidoName = item.querySelector('sidoName');
						const stationName = item.querySelector('stationName');
						const so2Value = item.querySelector('so2Value');
						const coValue = item.querySelector('coValue');
						const o3Value = item.querySelector('o3Value');
						const no2Value = item.querySelector('no2Value');
						const pm10Value = item.querySelector('pm10Value');
						const pm25Value = item.querySelector('pm25Value');
						const khaiValue = item.querySelector('khaiValue');
						const khaiGrade = item.querySelector('khaiGrade');
						
						tbody.innerHTML += `
							<tr>
								<td>\${index + 1}</td>
								<td>\${sidoName.textContent}</td>
								<td>\${stationName.textContent}</td>
								<td>\${so2Value.textContent}</td>
								<td>\${coValue.textContent}</td>
								<td>\${o3Value.textContent}</td>
								<td>\${no2Value.textContent}</td>
								<td>\${pm10Value.textContent}</td>
								<td>\${pm25Value.textContent}</td>
								<td>\${khaiValue.textContent}</td>
							</tr>
						`;
					});
					
				},
				error : console.log
			});
			
		});
		
		document.querySelector('#sidoName').addEventListener('change', (e) => {
			const sidoName = e.target.value;
			
			$.ajax({
				url : `${pageContext.request.contextPath}/publicData/xml/airpollutionChange.do?sidoName=\${sidoName}`,
				success(doc){
					console.log(doc);
					
					const items = doc.querySelectorAll('item');
					console.log(items);
					
					const tbody = document.querySelector("#tbl-xml-item-tbody");
					
					tbody.innerHTML = '';
					items.forEach((item, index) => {
						console.log(item);
						const sidoName = item.querySelector('sidoName');
						const stationName = item.querySelector('stationName');
						const so2Value = item.querySelector('so2Value');
						const coValue = item.querySelector('coValue');
						const o3Value = item.querySelector('o3Value');
						const no2Value = item.querySelector('no2Value');
						const pm10Value = item.querySelector('pm10Value');
						const pm25Value = item.querySelector('pm25Value');
						const khaiValue = item.querySelector('khaiValue');
						const khaiGrade = item.querySelector('khaiGrade');
						
						tbody.innerHTML += `
							<tr>
								<td>\${index + 1}</td>
								<td>\${sidoName.textContent}</td>
								<td>\${stationName.textContent}</td>
								<td>\${so2Value.textContent}</td>
								<td>\${coValue.textContent}</td>
								<td>\${o3Value.textContent}</td>
								<td>\${no2Value.textContent}</td>
								<td>\${pm10Value.textContent}</td>
								<td>\${pm25Value.textContent}</td>
								<td>\${khaiValue.textContent}</td>
							</tr>
						`;
					});
				},
				error : console.log
			});
		});
		</script>
	</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>