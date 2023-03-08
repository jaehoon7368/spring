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
			
			<table class="table" id="tbl-xml-student">
				<thead>
					<tr>
						<th>아이디</th>
						<th>이름</th>
						<th>전화번호</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
		<script>
		document.querySelector("#btn-course-xml").addEventListener('click', (e) => {
			$.ajax({
				url : '${pageContext.request.contextPath}/publicData/xml/course.do',
				success(doc){
					console.log(doc); // xml document
					const tblCourse = document.querySelector("#tbl-xml-course");
					const id = doc.querySelector("id");
					const title = doc.querySelector("title");
					const price = doc.querySelector("price");
					const created = doc.querySelector("created");
					tblCourse.querySelector(".id").innerHTML = id.textContent;
					tblCourse.querySelector(".title").innerHTML = title.textContent;
					tblCourse.querySelector(".price").innerHTML = price.textContent;
					tblCourse.querySelector(".created").innerHTML = created.textContent;
					
					// @실습문제 : student데이터 렌더링
					// student태그를 목록 조회 - forEach를 통해 student태그를 tr태그로 변환
					const students = doc.querySelectorAll("student");
					const tbody = document.querySelector("#tbl-xml-student tbody");
					tbody.innerHTML = ""; // 초기화
					students.forEach((student, index) => {
						const [id, name, tel] = student.children;
						console.log(id, name, tel);
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
		
		<h2>course - json</h2>
		<button class="btn btn-block btn-outline-primary" id="btn-course-json">확인</button>
		<div id="course-json-wrapper">
			<table class="table" id="tbl-json-course">
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
			
			<table class="table" id="tbl-json-student">
				<thead>
					<tr>
						<th>아이디</th>
						<th>이름</th>
						<th>전화번호</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
		<script>
		document.querySelector("#btn-course-json").addEventListener("click", (e) => {
			$.ajax({
				url : "${pageContext.request.contextPath}/publicData/json/course.do",
				success(data){
					console.log(data);
					const {id, title, price, created, students} = data;
					// #tbl-json-course 테이블 렌더
					const tblCourse = document.querySelector("#tbl-json-course");
					tblCourse.querySelector(".id").innerHTML = id;
					tblCourse.querySelector(".title").innerHTML = title;
					tblCourse.querySelector(".price").innerHTML = '￦' + price.toLocaleString();
					tblCourse.querySelector(".created").innerHTML = created;
					
					// #tbl-json-student 테이블 렌더
					const tbody = document.querySelector("#tbl-json-student tbody");
					tbody.innerHTML = "";
					students.forEach(({id, name, tel}) => {
						tbody.innerHTML += `
							<tr>
								<td>\${id}</td>
								<td>\${name}</td>
								<td>\${tel}</td>
							</tr>
						`;
					});
					
				},
				error : console.log
			});
		});
		</script>
		
		<h2>대기오염 - xml</h2>
		<!-- <button class="btn btn-block btn-outline-primary" id="btn-airpollution-xml">확인</button> -->
		<select class="custom-select" id="select-airpollution-xml">
			<option>시도이름</option>
			<option>전국</option>
			<option>서울</option>
			<option>부산</option>
			<option>대구</option>
			<option>인천</option>
			<option>광주</option>
			<option>대전</option>
			<option>경기</option>
		</select>
		<div id="airpollution-xml-wrapper">
		
		</div>
		<script>
		// document.querySelector("#btn-airpollution-xml").addEventListener('click', (e) => {
		document.querySelector("#select-airpollution-xml").addEventListener('change', (e) => {
			
			$.ajax({
				url: "${pageContext.request.contextPath}/publicData/xml/airpollution.do",
				data : {sidoName : e.target.value},
				success(doc){
					console.log(doc);
					const container = document.querySelector("#airpollution-xml-wrapper");
					let html = `
						<table class='table'>
							<thead>
								<tr>
									<th>No</th>
									<th>지역</th>
									<th>측정소</th>
									<th>아황산가스</th>
									<th>일산화탄소</th>
									<th>오존</th>
									<th>이산화질소</th>
									<th>미세먼지(PM10)</th>
									<th>미세먼지(PM2.5)</th>
									<th>통합대기환경</th>
								</tr>
							</thead>
							<tbody>`;
					const items = doc.querySelectorAll("item");
					console.log(items);
					
					items.forEach((item, index) => {
						const sidoName = item.querySelector("sidoName");
						const stationName = item.querySelector("stationName");
						
						const so2Grade = item.querySelector("so2Grade");
						const coGrade = item.querySelector("coGrade");
						const o3Grade = item.querySelector("o3Grade");
						const no2Grade = item.querySelector("no2Grade");
						const pm10Grade = item.querySelector("pm10Grade");
						const pm25Grade = item.querySelector("pm25Grade");
						const khaiGrade = item.querySelector("khaiGrade");
						
						const so2Value = item.querySelector("so2Value");
						const coValue = item.querySelector("coValue");
						const o3Value = item.querySelector("o3Value");
						const no2Value = item.querySelector("no2Value");
						const pm10Value = item.querySelector("pm10Value");
						const pm25Value = item.querySelector("pm25Value");
						const khaiValue = item.querySelector("khaiValue");
						
						const so2Flag = item.querySelector("so2Flag");
						const coFlag = item.querySelector("coFlag");
						const o3Flag = item.querySelector("o3Flag");
						const no2Flag = item.querySelector("no2Flag");
						const pm10Flag = item.querySelector("pm10Flag");
						const pm25Flag = item.querySelector("pm25Flag");
						
						html += `
							<tr>
								<td>\${index + 1}</td>
								<td>\${sidoName.textContent}</td>
								<td>\${stationName.textContent}</td>
								<td>\${getBadge(so2Grade.textContent)} \${so2Value.textContent}</td>
								<td>\${getBadge(coGrade.textContent)} \${coValue.textContent}</td>
								<td>\${getBadge(o3Grade.textContent)} \${o3Value.textContent}</td>
								<td>\${getBadge(no2Grade.textContent)} \${no2Value.textContent}</td>
								<td>\${getBadge(pm10Grade.textContent)} \${pm10Value.textContent}</td>
								<td>\${getBadge(pm25Grade.textContent)} \${pm25Value.textContent}</td>
								<td>\${getBadge(khaiGrade.textContent)} \${khaiValue.textContent}</td>
							</tr>
						`;
						
					});
					
					html += `		
							</tbody>
						</table>
					`;
					container.innerHTML = html;
				},
				error: console.log
			})
			
		});
		
		const getBadge = (grade) => {
			switch(grade){
			case "1" : return '<span class="badge badge-primary">좋음</span>';
			case "2" : return '<span class="badge badge-success">보통</span>';
			case "3" : return '<span class="badge badge-warning">나쁨</span>';
			case "4" : return '<span class="badge badge-danger">매우나쁨</span>';
			default : return '';
			}
		}
		</script>
		
		<h2>대기오염 - json</h2>
		<select class="custom-select" id="select-airpollution-json">
			<option>시도이름</option>
			<option>전국</option>
			<option>서울</option>
			<option>부산</option>
			<option>대구</option>
			<option>인천</option>
			<option>광주</option>
			<option>대전</option>
			<option>경기</option>
		</select>
		<div id="airpollution-json-wrapper"></div>
		<script>
		document.querySelector("#select-airpollution-json").addEventListener('change', (e) => {
			$.ajax({
				url : "${pageContext.request.contextPath}/publicData/json/airpollution.do",
				data : {sidoName : e.target.value},
				success(data){
					console.log(data);
					const container = document.querySelector("#airpollution-json-wrapper");
					let html = `
						<table class='table'>
							<thead>
								<tr>
									<th>No</th>
									<th>지역</th>
									<th>측정소</th>
									<th>아황산가스</th>
									<th>일산화탄소</th>
									<th>오존</th>
									<th>이산화질소</th>
									<th>미세먼지(PM10)</th>
									<th>미세먼지(PM2.5)</th>
									<th>통합대기환경</th>
								</tr>
							</thead>
							<tbody>`;
					// items 가져오기 - 구조분해할당
					const {response : {body : {items}}} = data
					console.log(items);
					
					items.forEach((item, index) => {
						const {coFlag, coGrade, coValue, dataTime, khaiGrade, khaiValue ,mangName ,no2Flag ,no2Grade ,no2Value ,o3Flag ,o3Grade ,o3Value ,pm10Flag ,pm10Grade ,pm10Grade1h ,pm10Value ,pm10Value24 ,pm25Flag ,pm25Grade ,pm25Grade1h ,pm25Value ,pm25Value24 ,sidoName ,so2Flag ,so2Grade ,so2Value ,stationName } = item;
						
						html += `
							<tr>
								<td>\${index + 1}</td>
								<td>\${sidoName}</td>
								<td>\${stationName}</td>
								<td>\${getBadge(so2Grade)} \${nvl(so2Value)}</td>
								<td>\${getBadge(coGrade)} \${nvl(coValue)}</td>
								<td>\${getBadge(o3Grade)} \${nvl(o3Value)}</td>
								<td>\${getBadge(no2Grade)} \${nvl(no2Value)}</td>
								<td>\${getBadge(pm10Grade)} \${nvl(pm10Value)}</td>
								<td>\${getBadge(pm25Grade)} \${nvl(pm25Value)}</td>
								<td>\${getBadge(khaiGrade)} \${nvl(khaiValue)}</td>
							</tr>
						`;
						
					});
					
					html += `		
							</tbody>
						</table>
					`;
					container.innerHTML = html;
				},
				error: console.log
			});
		});
		
		const nvl = (value) => value ? value : '';
		</script>
		
		<h2>내가 찾은 공공데이터(경찰청_범죄발생장소별 통계-2021)</h2>
		<button class="btn btn-block btn-outline-primary" id="btn-police-json">확인</button>
		<div id="policy-json-wrapper">
			<table class="table" id="tbl-json-policy">
				<thead>
					<tr>
						<th>범죄대분류</th>
						<th>범죄중분류</th>
						<th>아파트_연립다세대</th>
						<th>단독주택</th>
						<th>고속도로</th>
						<th>노상</th>
						<th>슈퍼마켓</th>
						<th>편의점</th>
						<th>사무실</th>
						<th>지하철</th>
						<th>공중화장실</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
		<script>
		document.querySelector("#btn-police-json").addEventListener('click',(e)=>{
			$.ajax({
				url : "${pageContext.request.contextPath}/publicData/json/policy.do",
				success(data){
					console.log(data);
					const tbody = document.querySelector("#tbl-json-policy tbody");
					tbody.innerHTML = "";
					const pol = data.data;
					console.log(pol);
					pol.forEach((police)=>{
						tbody.innerHTML += `
							<tr>
								<td>\${police.범죄대분류}</td>
								<td>\${police.범죄중분류}</td>
								<td>\${police.아파트_연립다세대}</td>
								<td>\${police.단독주택}</td>
								<td>\${police.고속도로}</td>
								<td>\${police.노상}</td>
								<td>\${police.슈퍼마켓}</td>
								<td>\${police.편의점}</td>
								<td>\${police.사무실}</td>
								<td>\${police.지하철}</td>
								<td>\${police.공중화장실}</td>
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