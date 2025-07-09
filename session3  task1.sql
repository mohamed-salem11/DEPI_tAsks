create database company
create table empolyee
(
id int primary key,
name varchar(30),
departmentid int not null
);
alter table empolyee add constraint  c1 foreign key (departmentid) references department (id)
alter table empolyee add salary int
alter table empolyee alter column name varchar(50)
create table department
(
 id int primary key,
name varchar(30),
employeeid int foreign key (employeeid)references empolyee (id)

);

create table project
(
  id int primary key,
 name varchar(30)  unique,
 type varchar(30) default'ecommerce',
 salary int ,
 departmentid int,
constraint a check(salary>30000),
constraint b foreign key (departmentid) references department(id) 
);
alter table project drop constraint a 

create table project_emoplyee
(
departmentid int,
projectid int
foreign key (departmentid) references department(id) ,
foreign key (projectid) references project(id) 
)
create table dependent
(
id int primary key,
age int,
name varchar(30)

)
alter table  dependent  add  dependentid int;
alter table  dependent  add   constraint d foreign key (dependentid) references empolyee (id);

INSERT INTO department (id, name)
VALUES 
(1, 'HR'),
(2, 'IT'),
(3, 'Marketing');
INSERT INTO empolyee (id, name, departmentid, salary)
VALUES 
(12, 'Ahmed', 1, 40000),
(23, 'Sara', 2, 50000),
(31, 'Omar', 3, 45000);



INSERT INTO dependent (id, age, name, dependentid)
VALUES 
(1, 6, 'Hana', 1),
(2, 8, 'Youssef', 2),
(3, 5, 'Lina', 3);

INSERT INTO project (id, name, type, salary, departmentid)
VALUES 
(1, 'E-Commerce Website', 'ecommerce', 60000, 2),
(2, 'Mobile App', 'mobile', 55000, 2),
(3, 'Marketing Campaign', 'ads', 70000, 3);


INSERT INTO project_emoplyee (departmentid, projectid)
VALUES 
(2, 1),
(2, 2),
(3, 3);



