--===========================
-- 관리자계정
--===========================
alter session set"_oracle_script" = true;

create user spring identified by spring
default tablespace users;

alter user spring quota unlimited on users;

grant connect,resource to spring;

--===========================
-- spring계정
--===========================
--dev테이블 생성
create table dev(
    no number,
    name varchar2(50) not null,
    career number not null,
    email varchar2(200) not null,
    gender char(1),
    lang varchar2(100) not null,
    created_at date default sysdate,
    constraint pk_dev_no primary key(no),
    constraint ch_dev_gender check(gender in ('M','F'))
);

create sequence seq_dev_no;

select * from dev;

-- 회원테이블
create table member(
    member_id varchar2(50),
    password varchar2(300) not null,
    name varchar2(256) not null,
    birthday date,
    email varchar2(256),
    phone char(11) not null,
    created_at date default sysdate,
    enabled number default 1,
    constraint pk_member_id primary key(member_id),
    constraint ck_member_enabled check(enabled in (1,0))
);

insert into spring.member values ('abcde','1234','아무개',to_date('88-01-25','rr-mm-dd'),'abcde@naver.com','01012345678', default, default);
insert into spring.member values ('qwerty','1234','김말년',to_date('78-02-25','rr-mm-dd'),'qwerty@naver.com','01098765432', default, default);
insert into spring.member values    ('admin','1234','관리자',to_date('90-12-25','rr-mm-dd'),'admin@naver.com','01012345678', default, default);

select * from member;

update 
    member 
set 
    password = '$2a$10$VAr4iXUEnfatGtDGNSG8feg0ZiOyvs5cN0rmYv9HSVVCxOBU2aIiq'
where
    member_id = 'leess';
    
    
--todo테이블 생성
create table todo(
    no number,
    todo varchar2(4000),
    created_at date default sysdate,
    completed_at date,
    constraint pk_todo_no primary key(no)
);
create sequence seq_todo_no;

insert into todo values(seq_todo_no.nextval,'에어컨 청소하기',default,null);
insert into todo values(seq_todo_no.nextval,'형광등 교체하기',default,null);
insert into todo values(seq_todo_no.nextval,'GoF의 디자인패턴 책읽기',default,null);
insert into todo values(seq_todo_no.nextval,'장보기',default,null);

select * from todo;

-- 할일완료
update todo set completed_at = sysdate where no = 4;
update todo set completed_at = sysdate where no = 2;

-- 할일목록 조회
-- 할일은 no오름차순, 완료된일은 completed_at 내림차순

--할일목록
select
    *
from(
    select * from todo where completed_at is null order by no
)
union all
--완료목록
select
    *
from(
    select * from todo where completed_at is not null order by completed_at desc
);

--게시판 테이블
create table board(
    no number,
    title varchar2(2000),
    member_id varchar2(15),
    content varchar2(4000),
    read_count number default 0,
    created_at date default sysdate,
    constraint pk_board_no primary key(no),
    constraint fk_board_member_id foreign key(member_id) references member(member_id)
        on delete set null
);

create sequence seq_board_no;

--첨부파일 테이블
create table attachment(
    no number,
    board_no number not null,
    original_filename varchar2(256) not null,
    renamed_filename varchar2(256) not null,
    download_count number default 0,
    created_at date default sysdate,
    constraint pk_attachment_no primary key(no),
    constraint fk_attachment_board_no foreign key(board_no) references board(no) on delete cascade
);
    
create sequence seq_attachment_no;

-- 게시판 샘플
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 1','abcde','반갑습니다',to_date('18/02/10','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 2','qwerty','안녕하세요',to_date('18/02/12','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 3','admin','반갑습니다',to_date('18/02/13','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 4','abcde','안녕하세요',to_date('18/02/14','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 5','qwerty','반갑습니다',to_date('18/02/15','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 6','admin','안녕하세요',to_date('18/02/16','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 7','abcde','반갑습니다',to_date('18/02/17','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 8','qwerty','안녕하세요',to_date('18/02/18','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 9','admin','반갑습니다',to_date('18/02/19','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 10','abcde','안녕하세',to_date('18/02/20','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 11','qwerty','반갑습니다',to_date('18/03/11','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 12','admin','안녕하세',to_date('18/03/12','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 13','abcde','반갑습니다',to_date('18/03/13','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 14','qwerty','안녕하세',to_date('18/03/14','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 15','admin','반갑습니다',to_date('18/03/15','RR/MM/DD'),0);


Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 16','abcde','안녕하세',to_date('18/03/16','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 17','qwerty','반갑습니다',to_date('18/03/17','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 18','admin','안녕하세',to_date('18/03/18','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 19','abcde','반갑습니다',to_date('18/03/19','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 20','qwerty','안녕하세',to_date('18/03/20','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 21','admin','반갑습니다',to_date('18/04/01','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 22','abcde','안녕하세',to_date('18/04/02','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 23','qwerty','반갑습니다',to_date('18/04/03','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 24','admin','안녕하세',to_date('18/04/04','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 25','abcde','반갑습니다',to_date('18/04/05','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 26','qwerty','안녕하세',to_date('18/04/06','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 27','admin','반갑습니다',to_date('18/04/07','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 28','abcde','안녕하세',to_date('18/04/08','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 29','qwerty','반갑습니다',to_date('18/04/09','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 30','admin','안녕하세',to_date('18/04/10','RR/MM/DD'),0);

Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 31','abcde','반갑습니다',to_date('18/04/16','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 32','qwerty','안녕하세',to_date('18/04/17','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 33','admin','반갑습니다',to_date('18/04/18','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 34','abcde','안녕하세',to_date('18/04/19','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 35','qwerty','반갑습니다',to_date('18/04/20','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 36','admin','안녕하세',to_date('18/05/01','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 37','abcde','반갑습니다',to_date('18/05/02','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 38','qwerty','안녕하세',to_date('18/05/03','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 39','admin','반갑습니다',to_date('18/05/04','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 40','abcde','안녕하세',to_date('18/05/05','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 41','qwerty','반갑습니다',to_date('18/05/06','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 42','admin','안녕하세',to_date('18/05/07','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 43','abcde','반갑습니다',to_date('18/05/08','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 44','qwerty','안녕하세',to_date('18/05/09','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 45','admin','반갑습니다',to_date('18/05/10','RR/MM/DD'),0);

Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 46','abcde','안녕하세',to_date('18/05/16','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 47','qwerty','반갑습니다',to_date('18/05/17','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 48','admin','안녕하세',to_date('18/05/18','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 49','abcde','반갑습니다',to_date('18/05/19','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 50','qwerty','안녕하세',to_date('18/05/20','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 51','admin','반갑습니다',to_date('18/05/01','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 52','abcde','안녕하세',to_date('18/06/02','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 53','qwerty','반갑습니다',to_date('18/06/03','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 54','admin','안녕하세',to_date('18/06/04','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 55','abcde','반갑습니다',to_date('18/06/05','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 56','qwerty','안녕하세',to_date('18/06/06','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 57','admin','반갑습니다',to_date('18/06/07','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 58','abcde','안녕하세',to_date('18/06/08','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 59','qwerty','반갑습니다',to_date('18/06/09','RR/MM/DD'),0);
Insert into SPRING.BOARD (NO,TITLE,MEMBER_ID,CONTENT,CREATED_AT,READ_COUNT) values (SEQ_BOARD_NO.nextval,'안녕하세요, 게시판입니다 - 60','admin','안녕하세',to_date('18/06/10','RR/MM/DD'),0);


INSERT INTO ATTACHMENT VALUES(SEQ_ATTACHMENT_NO.NEXTVAL, 60, 'test.jpg', '20200525_090909_123.JPG', DEFAULT, DEFAULT);

INSERT INTO ATTACHMENT VALUES(SEQ_ATTACHMENT_NO.NEXTVAL, 60, 'moon.jpg', '20200525_090909_345.JPG', DEFAULT, DEFAULT);

INSERT INTO ATTACHMENT VALUES(SEQ_ATTACHMENT_NO.NEXTVAL, 59, 'sun.jpg', '20200525_020425_345.JPG', DEFAULT, DEFAULT);

COMMIT;

select * from board;
select * from attachment;

-- 게시글 한건조회(join)
-- board(1) - attachment(n)
select
    b.*,
    a.*,
    a.no attach_no,
    m.*
from
    board b left join attachment a
    on b.no = a.board_no
    left join member m
    on b.member_id = m.member_id
where
    b.no = 64;
    
select * from member;

--권한테이블 생성
create table authority(
    member_id varchar2(20),
    auth varchar2(50),
    constraint pk_authority primary key(member_id,auth),
    constraint fk_authority_member_id foreign key(member_id)
                        references member(member_id)
                        on delete cascade
);

insert into authority values('leess','ROLE_USER');
insert into authority values('admin','ROLE_ADMIN');

--security가 원하는 사용자 조회
select * from member where member_id ='honggd';
select * from authority where member_id ='honggd';

create table persistent_logins (
    username varchar2(64) not null,
    series varchar2(64) primary key,
    token varchar2(64) not null, -- username, password, expiry time 등을 hashing한 값
    last_used timestamp not null
);

select * from persistent_logins;

-- menu restful api
create table menu(
    id number,
    restaurant varchar2(512) not null, --음식점
    name varchar2(256) not null, --메뉴이름
    price number,
    type varchar2(10) not null, --한식kr/중식ch/일식jp
    taste varchar2(10) not null,--순한맛 mild/매운맛 hot
    constraint pk_menu_id primary key(id),
    constraint uq_menu unique (restaurant,name,taste)
);

create sequence seq_menu_id;

insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'두리순대국','순대국',7000,'kr','mild');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'두리순대국','순대국',7000,'kr','hot');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'장터','뚝배기 김치찌게',7000,'kr','hot');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'만리향','간짜장',5000,'ch','mild');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'만리향','짬뽕',6000,'ch','hot');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'짬뽕지존','짬뽕',9000,'ch','mild');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'김남완초밥집','완초밥',13000,'jp','mild');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'김남완초밥집','런치초밥',10000,'jp','mild');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'김남완초밥집','참치도로초밥',33000,'jp','mild');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'진가와','자루소면',8000,'jp','mild');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'진가와','자루소바',9000,'jp','mild');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'백운봉','막국수',9000,'kr','hot');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'대우부대찌게','부대지게',10000,'kr','hot');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'봉된장','열무비빔밥+우렁된장',7000,'kr','hot');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'대우부대찌게','부대찌게',10000,'kr','hot');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'산들애','딸기',500,'kr','hot');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'대우부대찌게','청국장',13000,'kr','mild');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'스타동','사케동',8400,'jp','mild');
	insert into spring.menu (id,restaurant,name,price,type,taste) values (seq_menu_id.nextval,'진씨화로','돌솥비빔밥',7000,'kr','mild');
    
select * from menu;

