<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=basePath%>">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function () {

            $("#loginAct").focus();

            //按回车登录
            $(window).keydown(function (event) {
                if(event.keyCode==13){
                    $("#loginBtn").click();
                }
            })

            $("#loginBtn").click(function () {
                var loginAct = $("#loginAct").val();
                var loginPwd = $("#loginPwd").val();
                var isRemPwd = $("#isRemPwd").prop("checked");
                if(loginAct==""||loginPwd==""){
                    $("#msg").html("用户名或密码不能为空");
                    return;
                }

                $("#msg").html("正在努力验证中....");
                $.ajax({
                    url:"settings/qx/user/login.do",
                    type:"post",
                    data:{
                        loginAct:loginAct,
                        loginPwd:loginPwd,
                        isRemPwd:isRemPwd
                    },
                    dataType:"json",
                    success:function (resp) {
                        //登录失败
                        if(resp.code=="0"){
                            $("#msg").css("color","red");
                            $("#msg").html(resp.message);
                        }else {
                            //登录成功
                            window.location.href="workbench/toIndex.do";
                        }

                    },
                    error:function () {
                        alert("ajax发送失败")
                    }
                })
            })
        });
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="/WEB-INF/pages/workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" id="loginAct" type="text" placeholder="用户名" value="${cookie.loginAct.value}">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" id="loginPwd" type="password" placeholder="密码" value="${cookie.loginPwd.value}">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">
                    <label>
                        <c:if test="${not empty cookie.loginAct.value and not empty cookie.loginPwd.value}">
                            <input id="isRemPwd" type="checkbox" checked> 十天内免登录
                        </c:if>
                        <c:if test="${empty cookie.loginAct.value and empty cookie.loginPwd.value}">
                            <input id="isRemPwd" type="checkbox" > 十天内免登录
                        </c:if>
                    </label>
                    &nbsp;&nbsp;
                    <span id="msg" style="color: red"></span>
                </div>
                <button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>