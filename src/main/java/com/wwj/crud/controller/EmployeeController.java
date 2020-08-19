package com.wwj.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import com.wwj.crud.bean.Employee;
import com.wwj.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * 处理员工CRUD请求
 *
 * @author wwj
 *
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    @RequestMapping("/emps")
    public String getEmps(
            @RequestParam(value = "pn", defaultValue = "1") Integer pn,
            Model model) {
        // 引入PageHelper分页插件
        // 在查询之前只需要调用，传入页码，以及每页的大小
        PageHelper.startPage(pn, 5);
        // startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        // 使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了。
        // 封装了详细的分页信息,包括有我们查询出来的数据，传入连续显示的页数
        PageInfo page = new PageInfo(emps, 5);
        model.addAttribute("pageInfo", page);
        return "list";
    }

    /**
     * 学生保存
     */
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public String saveEmp(Employee employee){
        employeeService.saveEmp(employee);
        return "success";
    }

    /**
     * 检查姓名是否重复
     * @param empName
     * @return
     */
    @RequestMapping(value = "/checkuser",method = RequestMethod.POST)
    @ResponseBody
    public String checkuser(@RequestParam("empName") String empName){
        boolean flag = employeeService.checkUser(empName);
        if(flag){
            return "success";
        }else{
            return "fail";
        }
    }

    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public String getEmp(@PathVariable("id") Integer id){
        Employee employee = employeeService.getEmp(id);
        return employee.getEmpName() + '#' + employee.getEmail() + '#' + employee.getGender();
    }

    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public String updateEmp(Employee employee){
        System.out.println(employee);
        employeeService.updateEmp(employee);
        return "success";
    }

    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.DELETE)
    public String deleteEmp(@PathVariable("id") Integer id){
        employeeService.deleteEmp(id);
        return "success";
    }
}
