package com.wwj.crud.test;

import com.wwj.crud.bean.Department;
import com.wwj.crud.bean.Employee;
import com.wwj.crud.dao.DepartmentMapper;
import com.wwj.crud.dao.EmployeeMapper;
import org.junit.Test;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.UUID;

/**
 * 测试dao层
 */
public class MapperTest {

    @Test
    public void testCRUD(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        DepartmentMapper departmentMapper = context.getBean(DepartmentMapper.class);
        EmployeeMapper employeeMapper = context.getBean(EmployeeMapper.class);
        SqlSessionTemplate sqlSession = context.getBean(SqlSessionTemplate.class);
//        System.out.println(departmentMapper);

        //插入部门信息
//        departmentMapper.insertSelective(new Department(null,"开发部"));
//        departmentMapper.insertSelective(new Department(null,"测试部"));

        //插入员工信息
//        employeeMapper.insertSelective(new Employee(null,"AA","M","AA@163.com",1));

        //批量插入多个员工

        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0;i < 100;++i) {
            String uid = UUID.randomUUID().toString().substring(0,5);
            mapper.insertSelective(new Employee(null, uid, "M", uid + "@163.com", 1));
        }
    }
}
