<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=basePath%>">

</head>
<body>
<script type="text/javascript">
    window.location.href = "settings/qx/user/toLogin.do";
</script>
</body>
</html>