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