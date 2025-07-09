create database system
create table department (
    dnum int primary key,
    dname varchar(50),
    mgrssn int unique,
    mgrstartdate date
);

create table employee (
    ssn int primary key,
    fname varchar(50),
    lname varchar(50),
    birthdate date,
    gender char(1),
    dnum int,
    supervisorssn int,
    foreign key (dnum) references department(dnum),
    foreign key (supervisorssn) references employee(ssn)
);

alter table department
add foreign key (mgrssn) references employee(ssn);

create table project (
    pnumber int primary key,
    pname varchar(50),
    plocation varchar(50),
    dnum int,
    foreign key (dnum) references department(dnum)
);

create table works_on (
    ssn int,
    pnumber int,
    hours float,
    primary key (ssn, pnumber),
    foreign key (ssn) references employee(ssn),
    foreign key (pnumber) references project(pnumber)
);

create table dependent (
    dependentname varchar(50),
    ssn int,
    gender char(1),
    birthdate date,
    primary key (dependentname, ssn),
    foreign key (ssn) references employee(ssn) on delete cascade
);

insert into department (dnum, dname, mgrssn, mgrstartdate)
values (1, 'hr', null, '2020-01-01'),
       (2, 'it', null, '2021-03-15'),
       (3, 'finance', null, '2019-11-05');

insert into employee (ssn, fname, lname, birthdate, gender, dnum, supervisorssn)
values (101, 'ali', 'kamel', '1990-05-12', 'm', 1, null),
       (102, 'sara', 'hassan', '1992-08-30', 'f', 1, 101),
       (103, 'omar', 'saeed', '1988-01-25', 'm', 2, 101),
       (104, 'nora', 'ali', '1995-07-10', 'f', 2, 102),
       (105, 'khaled', 'fathy', '1993-04-18', 'm', 3, 103);

update department set mgrssn = 101 where dnum = 1;
update department set mgrssn = 103 where dnum = 2;
update department set mgrssn = 105 where dnum = 3;

insert into project values (1001, 'website', 'cairo', 2);
insert into project values (1002, 'payroll', 'alex', 3);
insert into project values (1003, 'hiring', 'giza', 1);

insert into works_on values (101, 1001, 10);
insert into works_on values (102, 1001, 15);
insert into works_on values (103, 1002, 20);
insert into works_on values (109, 1009, 25),
 (105, 1002, 30);

insert into dependent values ('youssef', 101, 'm', '2015-09-01');
insert into dependent values ('laila', 102, 'f', '2016-03-20');

update employee set dnum = 2 where ssn = 102;

delete from dependent where dependentname = 'laila' and ssn = 102;

select * from employee where dnum = 2;
