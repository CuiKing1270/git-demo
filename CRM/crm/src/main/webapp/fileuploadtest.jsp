<%@ page contentType="text/html; charset=UTF-8" language="java" %>、
<%--添加jstl标签库--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--动态获取访问地址--%>
<% String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";%>

<html>
<head>
    <base href="<%=basePath%>">
    <title>文件上传演示</title>

</head>
<body>
    <form action="url" method="post" enctype="multipart/form-data">
        <input type="file" name="myFile"/><br/>
        <input type="text" name="userName"/><br/>
        <input type="submit" name="提交"/><br/>

    </form>
</body>
</html>
