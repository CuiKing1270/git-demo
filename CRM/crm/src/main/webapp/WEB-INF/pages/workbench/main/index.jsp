<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--动态获取地址
	request.getScheme() 获取http协议
	request.getServerName() 获取访问地址
	request.getServerPort() 获取访问端口号
	request.getContextPath() 获取工程地址
-->
<% String basePath= request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

</head>
<body>
	<img src="image/home.png" style="position: relative;top: -10px; left: -10px;"/>
</body>
</html>