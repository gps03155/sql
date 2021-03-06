-- subquery --
-- 단일 행인 경우 --
-- <, >, =, !=, <=, >= --

select e.emp_no, d.dept_no
from employees e join dept_emp d on e.emp_no = d.emp_no
where concat(e.first_name, ' ', e.last_name) = 'Fai Bale'
		and d.to_date = '9999-01-01';

select e.emp_no, e.first_name
from employees e join dept_emp d on e.emp_no = d.emp_no
where d.dept_no = 'd004';

-- 단일행 서브쿼리 --

select e.emp_no, e.first_name
from employees e join dept_emp d on e.emp_no = d.emp_no
where d.dept_no = (select d.dept_no
					from employees e join dept_emp d on e.emp_no = d.emp_no
					where concat(e.first_name, ' ', e.last_name) = 'Fai Bale'
					and d.to_date = '9999-01-01');

select e.emp_no, e.first_name
from employees e join dept_emp d on e.emp_no = d.emp_no
where (e.emp_no, d.dept_no) = (select e.emp_no, d.dept_no
							from employees e join dept_emp d on e.emp_no = d.emp_no
							where concat(e.first_name, ' ', e.last_name) = 'Fai Bale'
							and d.to_date = '9999-01-01');


-- ex1 --

select e.first_name, s.salary
from employees e join salaries s on e.emp_no = s.emp_no
where s.to_date = '9999-01-01'
	  and s.salary < (select avg(salary)
					  from salaries
					  where to_date = '9999-01-01')
order by s.salary desc;
                      
select avg(salary)
from salaries
where to_date = '9999-01-01';


-- ex2 : 직책별 가장 작은 평균 연봉 --

select t.title, round(avg(s.salary)) as 'avg_salary'
from salaries s join titles t on s.emp_no = t.emp_no
where s.to_date = '9999-01-01' and t.to_date = '9999-01-01'
group by t.title
order by avg_salary asc 
limit 0, 1; -- 0부터 1개 가져옴 (index : 0부터 시작) --

select min(avg_salary)
from (select t.title, round(avg(s.salary)) as 'avg_salary'
		from salaries s join titles t on s.emp_no = t.emp_no
		where s.to_date = '9999-01-01' and t.to_date = '9999-01-01'
		group by t.title) result;
        
select t.title, round(avg(s.salary)) as 'avg_salary'
from salaries s join titles t on s.emp_no = t.emp_no
where s.to_date = '9999-01-01' and t.to_date = '9999-01-01'
group by t.title
having avg_salary = (select min(avg_salary)
						from (select t.title, round(avg(s.salary)) as 'avg_salary'
								from (salaries s join titles t on s.emp_no = t.emp_no) join employees e on e.emp_no = s.emp_no
								where s.to_date = '9999-01-01' and t.to_date = '9999-01-01'
								group by t.title) result);


-- 다중행 서브쿼리 --
-- any --
-- = any : in과 동일한 의미
-- > any, < any, <> any (!=all 완전 동일), <= any, >= any

-- all
-- = all
-- > all, < all, <> all, <= all, >= all


select emp_no, salary
from salaries
where salary = any (select salary 
					from salaries);


-- ex1 : 현재 급여가 50000 이상인 직원 이름 출력

select emp_no
from salaries
where to_date = '9999-01-01' and salary > 50000;

select concat(first_name, ' ', last_name)
from employees
where emp_no = any (select emp_no
					from salaries
					where to_date = '9999-01-01' and salary > 50000);
                    

-- salary 같이 출력

select concat(first_name, ' ', last_name), s.salary
from employees e join salaries s on e.emp_no = s.emp_no
where s.to_date = '9999-01-01'
      and (e.emp_no, s.salary) = any (select emp_no, salary
			    				        from salaries
										where to_date = '9999-01-01' and salary > 50000);

select concat(first_name, ' ', last_name), s.salary
from employees e join salaries s on e.emp_no = s.emp_no
where s.to_date = '9999-01-01'
      and (e.emp_no, s.salary) in (select emp_no, salary
			    				   from salaries
								   where to_date = '9999-01-01' and salary > 50000);

select concat(e.first_name, ' ', e.last_name), result.salary
from employees e join (select emp_no, salary
					   from salaries
					   where to_date = '9999-01-01' and salary > 50000) result on e.emp_no = result.emp_no;
