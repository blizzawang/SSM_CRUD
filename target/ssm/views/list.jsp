<%--
  Created by IntelliJ IDEA.
  User: wwj
  Date: 2020/8/18 0018
  Time: 11:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>学生列表</title>

    <%-- 引入jQuery --%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-1.10.1.js"></script>
    <%-- 引入bootstrap --%>
    <link rel="stylesheet" href="<%request.getContextPath();%>static/bootstrap-3.3.7-dist/css/bootstrap.css">
    <script type="text/javascript"
            src="<%request.getContextPath();%>static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(function () {
            //绑定新增按钮的点击事件
            $('#emp_add_modal_btn').click(function () {
                $('#empAddModal').modal({
                    backdrop:"static"
                });
            });

            //绑定删除按钮的点击事件
            $(document).on("click",".delete_btn",function () {
                var delete_id = $(this).attr('delete-id');
                //弹出删除提示框
                if(confirm("确定删除吗?")){
                    //确认
                    $.ajax({
                        url:"${pageContext.request.contextPath}/emp/" + delete_id,
                        type:"POST",
                        data:"_method=DELETE",
                        success:function (data) {
                            if(data == "success"){
                                //重新加载页面
                                location.reload();
                            }
                        }
                    });
                }
            });

            //绑定编辑按钮的点击事件
            $(document).on("click",".edit_btn",function () {
                getEmp($(this).attr("edit-id"));
                //把学生的id传递给模态框的更新按钮
                $('#emp_update_btn').attr("edit-id",$(this).attr("edit-id"));
                //弹出编辑的模态框
                $('#empUpdateModal').modal({
                    backdrop: "static"
                });
            });
            
            function getEmp(id) {
                $.ajax({
                    url:"${pageContext.request.contextPath}/emp/" + id,
                    type:"GET",
                    contentType: "application/x-www-form-urlencoded; charset=utf-8",
                    success:function (data) {
                        var array = data.split('#');
                        $('#empName_update_static').text(array[0]);
                        $('#email_update_input').val(array[1]);
                        $('#empUpdateModal input[name=gender]').val([array[2]]);
                    }
                });
            }

            //绑定更新按钮的点击事件
            $('#emp_update_btn').click(function () {
                var edit_id = $(this).attr("edit-id");
                //验证手机号
                var number = $('#email_update_input').val();
                var regNumber = /^1[34578]\d{9}$/
                if(!regNumber.test(number)){
                    show_validate_msg("#email_update_input","error","手机号不合法,需要是以1开头的11位数字组合");
                    return false;
                }else{
                    show_validate_msg("#email_update_input","success","");
                }

                //发送ajax请求
                $.ajax({
                    url:"${pageContext.request.contextPath}/emp/" + edit_id,
                    type:"POST",
                    data:$("#empUpdateModal form").serialize() + "&_method=PUT",
                    success:function (data) {
                        if(data == "success"){
                            $('#empUpdateModal').modal('hide');
                            //更新完成后，重新加载当前页面，对更新数据进行重新加载
                            $.ajax({
                                url:"${pageContext.request.contextPath}/emps/?pn=" + ${pageInfo.pageNum},
                                type:"GET",
                                success:function () {
                                    location.reload();
                                }
                            });
                        }
                    }
                })
            });

            function validate_add_form(){
                //获取数据
                var name = $('#empName_add_input').val();
                var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
                if(!regName.test(name)){
                    // alert("姓名不合法!");
                    show_validate_msg("#empName_add_input","error","姓名不合法,需要是2~5个汉字");
                    return false;
                }else{
                    show_validate_msg('#empName_add_input',"success","");
                }
                var number = $('#email_add_input').val();
                var regNumber = /^1[34578]\d{9}$/
                if(!regNumber.test(number)){
                    // alert("手机号不合法!");
                    show_validate_msg("#email_add_input","error","手机号不合法,需要是以1开头的11位数字组合");
                    return false;
                }else{
                    show_validate_msg("#email_add_input","success","");
                }
                return true;
            }

            //显示校验的提示信息
            function show_validate_msg(elem,status,msg){
                //清除当前元素样式
                $(elem).parent().removeClass("has-success has-error");
                $(elem).next("span").text("");
                if(status == "success"){
                    $(elem).parent().addClass("has-success");
                    $(elem).next("span").text(msg);
                }else if(status == "error"){
                    $(elem).parent().addClass("has-error");
                    $(elem).next("span").text(msg);
                }
            }

            //发送ajax请求校验姓名是否重复
            $('#empName_add_input').change(function () {
                var empName = this.value;
                $.ajax({
                    url:"${pageContext.request.contextPath}/checkuser",
                    data:"empName=" + empName,
                    type:"POST",
                    success:function (data) {
                        if(data == "success"){
                            show_validate_msg("#empName_add_input","success","姓名可用");
                        }else{
                            show_validate_msg("#empName_add_input","error","姓名不可用");
                        }
                    }
                });
            });

            //绑定保存按钮的点击事件
            $('#emp_save_btn').click(function () {
                //将填写的学生信息交给服务器

                //首先对填入的数据进行校验
                if(!validate_add_form()) {
                    return false;
                }

                //发送ajax请求
               $.ajax({
                   url:"${pageContext.request.contextPath}/emp",
                   type:"POST",
                   data:$("#empAddModal form").serialize(),
                   success:function (data) {
                        if(data == 'success'){
                            alert("添加成功!");
                            //添加成功后，关闭模态框
                            $('#empAddModal').modal('hide');
                            //重新加载页面
                            location.reload();
                        }
                   }
                });
            });
        });
    </script>
</head>
<body>

<!-- 学生添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">学生添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group has-success">
                        <label for="empName_add_input" class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group has-success">
                        <label for="email_add_input" class="col-sm-2 control-label">联系电话</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">身份证号</label>
                        <div class="col-sm-10">
                            <p class="form-control-static">您无权修改!</p>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 学生修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">信息修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group has-success">
                        <label for="empName_add_input" class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group has-success">
                        <label for="email_add_input" class="col-sm-2 control-label">联系电话</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">身份证号</label>
                        <div class="col-sm-10">
                            <p class="form-control-static">您无权修改!</p>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<%-- 搭建显示页面 --%>
<div class="container">
    <%-- 标题 --%>
    <div class="row">
        <div class="col-md-12">
            <h1>学生管理系统</h1>
        </div>
    </div>
    <%-- 按钮 --%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <%-- 表格数据 --%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover">
                <tr>
                    <th>id</th>
                    <th>学生姓名</th>
                    <th>性别</th>
                    <th>联系电话</th>
                    <th>部门</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                    <tr>
                        <th>${emp.empId}</th>
                        <th>${emp.empName}</th>
                        <th>${emp.gender == 'M' ? '男' : '女'}</th>
                        <th>${emp.email}</th>
                        <th>${emp.department.deptName}</th>
                        <th>
                            <button class="btn btn-primary btn-sm edit_btn" edit-id=${emp.empId}>
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                编辑
                            </button>
                            <button class="btn btn-danger btn-sm delete_btn" delete-id="${emp.empId}">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                删除
                            </button>
                        </th>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <%-- 分页 --%>
    <div class="row">
        <%-- 分页信息 --%>
        <div class="col-md-6">
            当前第${pageInfo.pageNum}页,总${pageInfo.pages}页,总${pageInfo.total}条记录
        </div>
        <%-- 分页条信息 --%>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="${pageContext.request.contextPath}/emps?pn=1">首页</a></li>
                    <c:if test="${pageInfo.hasPreviousPage}">
                        <li>
                            <a href="${pageContext.request.contextPath}/emps?pn=${pageInfo.pageNum - 1}"
                               aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach items="${pageInfo.navigatepageNums}" var="pageNum">
                        <c:if test="${pageNum == pageInfo.pageNum}">
                            <li class="active"><a href="#">${pageNum}</a></li>
                        </c:if>
                        <c:if test="${pageNum != pageInfo.pageNum}">
                            <li><a href="${pageContext.request.contextPath}/emps?pn=${pageNum}">${pageNum}</a></li>
                        </c:if>
                    </c:forEach>
                    <c:if test="${pageInfo.hasNextPage}">
                        <li>
                            <a href="${pageContext.request.contextPath}/emps?pn=${pageInfo.pageNum + 1}"
                               aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <li><a href="${pageContext.request.contextPath}/emps?pn=${pageInfo.pages}">末页</a></li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
