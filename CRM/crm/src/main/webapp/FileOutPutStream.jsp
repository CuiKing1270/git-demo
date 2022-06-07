<%@ page contentType="text/html; charset=UTF-8" language="java" %>、
<%--添加jstl标签库--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--动态获取访问地址--%>
<% String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";%>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>文件的下载演示</title>
    <%--引入jquery--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script> <%--引入jquery框架--
    <%--编写入口函数 --%>
    <script>
        $(function () {
            $("#FileOutPutStreamBtn").click(function () {
                // 这里我们本来应该用异步请求的，但是文件下载只能是同步请求 所以我们这里使用同步请求
                // 同步请求的三种方式 1.地址栏  2.超链接 3.form表单
                // 这里用到了地址栏
                window.location.href="workbench/activity/ActivityFileExcel.do";
            });
        });
    </script>
</head>
<body>
<%--创建一个 下载按钮 当我们点击下载按钮的时候呢，我们向后台发出请求进行文件的下载--%>
<input type="button" value="下载" id="FileOutPutStreamBtn">
</body>
</html>
