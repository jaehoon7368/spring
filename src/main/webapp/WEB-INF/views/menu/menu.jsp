<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="Menu" name="title"/>
</jsp:include>
<style>
    div.menu-test{width:50%; margin:0 auto; text-align:center;}
    div.result{width:70%; margin:0 auto;}
</style>
<%--
	GET /menu : 모든메뉴조회
	
	GET /menu/type/kr : 한식만 조회 
	GET /menu/type/ch : 중식만 조회
	GET /menu/type/jp : 일식만 조회
	
	GET /menu/taste/mild : 순한맛만 조회
	GET /menu/taste/hot : 매운맛만 조회
	
	GET /menu/10 : 10번 메뉴 조회(한건 조회)
	
	POST /menu : 메뉴한건 등록 (실제 데이터를 json형식)
	
	PUT /menu : 메뉴 한건 전체수정 
	PATCH /menu : 메뉴 한건 일부수정
	
	DELETE /menu/10 : 메뉴 한건 삭제
 --%>	
 <%--
 	Access to XMLHttpRequest at 'http://localhost:10000/app/menu' from origin 'http://localhost:8080'
 	has been blocked by CORS policy: 
 	No 'Access-Control-Allow-Origin' header is present on the requested resource.
 
 	origin : protocol + host + port
 		- http:// localhost : 10000
 	
 	SOP policy Same Origin Policy 동일근원정책
 	- 브라우져에서 비동기요청은 같은 origin으로만 가능하다.
 	
 	CORS policy Cross Origin Resource Sharing Policy
 	- 요청에 대한 응답해더에 Acess-Control-Allow-Origin에 해당 origin이 작성되어 있어야 한다.
 	- Access-Control-Allow_Origin : http://localhsot:8080
 	- Access-Control-Allow_Origin : *
  --%>
 <div id="menu-container" class="text-center">
        <!-- 1.GET /menu -->
        <div class="menu-test">
            <h4>전체메뉴조회(GET)</h4>
            <input type="button" class="btn btn-block btn-outline-success btn-send" id="btn-menu" value="전송" />
        </div>
        <div class="result" id="menu-result"></div>
        <script>
        const MENU_URL = 'http://localhost:10000/app/menu';
        document.querySelector("#btn-menu").addEventListener("click",(e)=>{
        	$.ajax({
        		//url : MENU_URL,
        		url : '${pageContext.request.contextPath}/menu/findMenuList.do',
        		method : "GET",
        		success(data){
        			console.log(data); //js object (jquery가 json을 선변환후 전달)
        			renderMenuTable("#menu-result",data);
        		},
        		error : console.log
        	});
        });
        </script>
        
         <!-- 2.GET /menu/type/kr /menu/type/ch /menu/type/jp 타입별 조회 -->
        <div class="menu-test">
            <h4>메뉴 타입별 조회(GET)</h4>
            <select class="form-control" id="typeSelector">
                <option value="" disabled selected>음식타입선택</option>
                <option value="kr">한식</option>
                <option value="ch">중식</option>
                <option value="jp">일식</option>
            </select>
        </div>
        <div class="result" id="menuType-result"></div>
        <script>
        document.querySelector("#typeSelector").addEventListener('change',(e)=>{
        		console.log(e.target.value);
        		
        		$.ajax({
        			url : `\${MENU_URL}/type/\${e.target.value}`,
        			method : "GET",
        			success(data){
        				console.log(data);
        				renderMenuTable("#menuType-result",data);
        			},
        			error : console.log
        		});
        });
        </script>
        
        <!-- GET /menu/type/kr/taste/mild -->
        <div class="menu-test">
	        <h4>메뉴 타입/맛별 조회(GET)</h4>
	        <form name="menuTypeTasteFrm">
	            <div class="form-check form-check-inline">
	                <input type="radio" class="form-check-input" name="type" id="get-no-type" value="all" checked>
	                <label for="get-no-type" class="form-check-label">모두</label>&nbsp;
	                <input type="radio" class="form-check-input" name="type" id="get-kr" value="kr">
	                <label for="get-kr" class="form-check-label">한식</label>&nbsp;
	                <input type="radio" class="form-check-input" name="type" id="get-ch" value="ch">
	                <label for="get-ch" class="form-check-label">중식</label>&nbsp;
	                <input type="radio" class="form-check-input" name="type" id="get-jp" value="jp">
	                <label for="get-jp" class="form-check-label">일식</label>&nbsp;
	            </div>
	            <br />
	            <div class="form-check form-check-inline">
	                <input type="radio" class="form-check-input" name="taste" id="get-no-taste" value="all" checked>
	                <label for="get-no-taste" class="form-check-label">모두</label>&nbsp;
	                <input type="radio" class="form-check-input" name="taste" id="get-hot" value="hot">
	                <label for="get-hot" class="form-check-label">매운맛</label>&nbsp;
	                <input type="radio" class="form-check-input" name="taste" id="get-mild" value="mild">
	                <label for="get-mild" class="form-check-label">순한맛</label>
	            </div>
	            <br />
	            <input type="submit" class="btn btn-block btn-outline-success btn-send" value="전송" >
	        </form>
	    </div>
	    <div class="result" id="menuTypeTaste-result"></div>
	    <script>
	    document.menuTypeTasteFrm.addEventListener('submit',(e)=>{
	    	e.preventDefault();
	    	const type = e.target.type.value;
	    	const taste = e.target.taste.value;
	    	
	    	$.ajax({
	    		url : `\${MENU_URL}/type/\${type}/taste/\${taste}`,
	    		method : "GET",
	    		success(data){
    				console.log(data);
    				renderMenuTable("#menuTypeTaste-result",data);
    			},
    			error : console.log
	    	});
	    });
	    </script>
	  
	   <!-- POST /menu -->
	    <div class="menu-test">
	        <h4>메뉴 등록하기(POST)</h4>
	        <form name="menuEnrollFrm">
	            <input type="text" name="restaurant" placeholder="음식점" class="form-control" required/>
	            <br />
	            <input type="text" name="name" placeholder="메뉴" class="form-control" required/>
	            <br />
	            <input type="number" name="price" placeholder="가격" class="form-control" required/>
	            <br />
	            <div class="form-check form-check-inline">
	                <input type="radio" class="form-check-input" name="type" id="post-kr" value="kr" checked>
	                <label for="post-kr" class="form-check-label">한식</label>&nbsp;
	                <input type="radio" class="form-check-input" name="type" id="post-ch" value="ch">
	                <label for="post-ch" class="form-check-label">중식</label>&nbsp;
	                <input type="radio" class="form-check-input" name="type" id="post-jp" value="jp">
	                <label for="post-jp" class="form-check-label">일식</label>&nbsp;
	            </div>
	            <br />
	            <div class="form-check form-check-inline">
	                <input type="radio" class="form-check-input" name="taste" id="post-hot" value="hot" checked>
	                <label for="post-hot" class="form-check-label">매운맛</label>&nbsp;
	                <input type="radio" class="form-check-input" name="taste" id="post-mild" value="mild">
	                <label for="post-mild" class="form-check-label">순한맛</label>
	            </div>
	            <br />
	            <input type="submit" class="btn btn-block btn-outline-success btn-send" value="등록" >
	        </form>
	    </div>
	   <script>
            document.menuEnrollFrm.addEventListener('submit', (e) => {
                e.preventDefault();
                
                const menu = {
                    restaurant : e.target.restaurant.value,
                    name : e.target.name.value,
                    price : e.target.price.value,
                    type : e.target.type.value,
                    taste : e.target.taste.value
                };
                console.log(menu);
                
                const csrfHeader = "${_csrf.headerName}";
                const csrfToken = "${_csrf.token}";
                const headers = {};
                headers[csrfHeader] = csrfToken;
                
                $.ajax({
                    //url : MENU_URL,
                    url : '${pageContext.request.contextPath}/menu/enrollMenu.do',
                    //data : menu, // 직렬화 restaurant=두리순대국&name=순대국(특)&price=30000
                    data : JSON.stringify(menu),
                    method : 'POST',
                    headers,
                    contentType : 'application/json; charset=utf-8',
                    // [org.springframework.web.HttpMediaTypeNotSupportedException: Content type 'application/x-www-form-urlencoded;charset=UTF-8' not supported]
                    success(data, textStatus, jqxhr){
                        console.log(data);
                        console.log(textStatus);
                        console.log(jqxhr);
                        
                        const location = jqxhr.getResponseHeader('Location');
                        console.log(location);
                    },
                    error : console.log,
                    complete(){
                        e.target.reset();
                    }
                });
            });
        </script>
	    
	    <!-- #3.PUT -->
		<div class="menu-test">
			<h4>메뉴 수정하기(PUT)</h4>
			<p>메뉴번호를 사용해 해당메뉴정보를 수정함.</p>
			<form id="menuSearchFrm" name="menuSearchFrm">
				<input type="text" name="id" placeholder="메뉴번호" class="form-control" /><br />
				<input type="submit" class="btn btn-block btn-outline-primary btn-send" value="검색" >
			</form>
		
			<hr />
			<form id="menuUpdateFrm" name="menuUpdateFrm">
				<!-- where조건절에 사용할 id를 담아둠 -->
				<input type="hidden" name="id" />
				<input type="text" name="restaurant" placeholder="음식점" class="form-control" />
				<br />
				<input type="text" name="name" placeholder="메뉴" class="form-control" />
				<br />
				<input type="number" name="price" placeholder="가격" step="1000" class="form-control" />
				<br />
				<div class="form-check form-check-inline">
					<input type="radio" class="form-check-input" name="type" id="put-kr" value="kr" checked>
					<label for="put-kr" class="form-check-label">한식</label>&nbsp;
					<input type="radio" class="form-check-input" name="type" id="put-ch" value="ch">
					<label for="put-ch" class="form-check-label">중식</label>&nbsp;
					<input type="radio" class="form-check-input" name="type" id="put-jp" value="jp">
					<label for="put-jp" class="form-check-label">일식</label>&nbsp;
				</div>
				<br />
				<div class="form-check form-check-inline">
					<input type="radio" class="form-check-input" name="taste" id="put-hot" value="hot" checked>
					<label for="put-hot" class="form-check-label">매운맛</label>&nbsp;
					<input type="radio" class="form-check-input" name="taste" id="put-mild" value="mild">
					<label for="put-mild" class="form-check-label">순한맛</label>
				</div>
				<br />
				<input type="submit" class="btn btn-block btn-outline-success btn-send" value="수정" >
			</form>
		</div>
		<script>
		document.menuSearchFrm.addEventListener('submit',(e)=>{
			e.preventDefault();
			const id = document.querySelector("[name=id]").value;
			findById(id);
		});
		
		document.menuUpdateFrm.addEventListener('submit',(e)=>{
			e.preventDefault();
			
			const frmData = new FormData(e.target);
			const menu = {};
			frmData.forEach((value, key)=>{
				menu[key] = value;
			});
			console.log(JSON.stringify(menu));
			
			$.ajax({
				url : MENU_URL,
				method : "PUT",
				data : JSON.stringify(menu),
				contentType : 'application/json; charset=utf-8',
				success(data){
					console.log(data);
				},
				error : console.log
			});
		});
		</script>
		
		<!-- DELETE /menu/10 -->
		<div class="menu-test">
	        <h4>메뉴 삭제하기(DELETE)</h4>
	        <p>메뉴번호를 사용해 해당메뉴정보를 삭제함.</p>
	        <form id="menuDeleteFrm" name="menuDeleteFrm">
	            <input type="text" name="id" placeholder="메뉴번호" class="form-control" /><br />
	            <input type="submit" class="btn btn-block btn-outline-danger btn-send" value="삭제" >
	        </form>
	    </div>
	    <script>
	    document.menuDeleteFrm.addEventListener('submit',(e)=>{
	    	e.preventDefault();
	    		
	    	$.ajax({
	    		url : ${MENU_URL}/\${e.target.id.value}`,
	    		method : "DELETE",
	    		success(data){
	    			console.log(data); 
	    		},
	    		error : console.log
	    	})	
	    });
	    </script>
	    
</div> <!-- end of #menu-container -->
<script>
const findById = (id) =>{
	console.log(id);
	
	$.ajax({
		url : `\${MENU_URL}/\${id}`,
		method : "GET",
		success(data){
			console.log(data);
			const frm = document.menuUpdateFrm;
			const {id, restaurant,name,price,type,taste} = data;
			frm.id.value = id;
			frm.restaurant.value = restaurant;
			frm.name.value = name;
			frm.price.value = price;
			frm.type.value = type;
			frm.taste.value = taste;
		},
		error(jqxhr,textStatus,err){
			console.log(jqxhr,textStatus,err);
			if(jqxhr.status == 404){
				alert("조회한 메뉴는 존제하지 않습니다.");
			}
		}
	});
};
/**
 * selector하위에 메뉴테이블을 생성
 * ------------------------------
 * 번호 음식점 메뉴명 가격 타입 맛 
 * ------------------------------
 *....
 *	<table class="table">...
 */
const renderMenuTable = (selector,data)=>{
	const container = document.querySelector(selector);
	
	let html = `
		<table class="table table-hover">
		<thead>
			<tr>
				<th scope='col'>번호</th>
				<th scope='col'>음식점</th>
				<th scope='col'>메뉴명</th>
				<th scope='col'>가격</th>
				<th scope='col'>타입</th>
				<th scope='col'>맛/th>
			</tr>
		</thead>
		<tbody>
	`;
	
	//반복처리
	if(data.length){
		data.forEach((menu) =>{
			const {id, restaurant,name,price,type,taste} = menu;
			html +=`
				<tr data-id="\${id}">
					<td><a href="javascript:findById('\${id}')">\${id}</a></td>
					<td>\${restaurant}</td>
					<td>\${name}</td>
					<td>₩\${price.toLocaleString()}</td>
					<td>\${type}</td>
					<td>\${taste}</td>
				</tr>
			`;
			
		});		
	}else{
		html +='<tr><td class="text-center" colspan="6">조회된 결과가 없습니다.</td></tr>';
	}
	
	html +=`
		</tbody>
	</table>
	`;
	container.innerHTML = html;
};
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"></jsp:include>