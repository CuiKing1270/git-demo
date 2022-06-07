<%@ page contentType="text/html; charset=UTF-8" language="java" %>、
<%--添加jstl标签库--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--动态获取访问地址--%>
<% String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";%>

<html>
<head>
	<base href="<%=basePath%>">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});*/
		$("#remarkDivList").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		})
		
		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/
		$("#remarkDivList").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		})

		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/
		$("#remarkDivList").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		})
		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
		// on 事件 格式 父选择器.on("事件类型","子选择器",function(){js代码,也就是需要执行的事件});
		$("#remarkDivList").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		})
		// 给保存按钮添加单机事件,而且function函数的参数就是她本身
		$("#saveCreateActivityRemarkBtn").click(function () {
			// 首先我们需要收集参数
			let noteContent= $.trim($("#remark").val()); // 备注的描述信息
			let activityId = '${activity.id}'; // 如果 我们这里不加'' 那么浏览器就会将其当作变量，浏览器或报错undefined。
			// 收集参数之后 进行表单验证
			if ($("#noteContent")==""){
				alert("备注内容不能为空");
				return;
			}
			// 如果描述不为空 我们将发送ajax请求 noteContent 前面的key要和controller的属性值名字一样。
			$.ajax( {
				url:'workbench/activity/saveCreateActivityRemark.do',
				data:{
					noteContent:noteContent,
					activityId:activityId
				},
				type:'post',
				dataType:'json',
				// 回调函数  主要进行需求的处理  修改和删除通过id来进行信息的处理
				success:function (data) {
					if (data.code=="1"){
						// 清空,备注信息
						$("#remark").val("");
						<%--// 刷新列表  这里的需求就是直接拼接一个div ${sessionScope.sessionUser.name}  通过session域来获取对象数据，首先获取用户的对象然后获取用户的名字--%>
						let HtmlStr = "";
						HtmlStr+="<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
						HtmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\" >";
						HtmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
						HtmlStr+="<h5>"+data.retData.noteContent+"</h5>";
						HtmlStr+="<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${activity.name }</b> <small style=\"color: gray;\"> "+data.retData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
						HtmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						HtmlStr+="<a class=\"myHref\" remarkId = \""+data.retData.id+" \"href=\"javascript:void(0);\" name='editA'><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						HtmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
						HtmlStr+="<a class=\"myHref\" remarkId = \""+data.retData.id+"\" href=\"javascript:void(0);\" name='deleteA'><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						HtmlStr+="</div>";
						HtmlStr+="</div>";
						HtmlStr+="</div>";
						$("#remarkDiv").before(HtmlStr); // 将字符串添加到另一个标签的前面。选择器.before("htmlStr"); // Html字符串
					}else {
						alert(data.message) ;	// 进行提示信息
					}

				}
			});

		});

		// 进行删除  删除这个元素是动态生成的 所以我们这里要考虑用on函数  name 属性来获取元素的属性。 id 也可以 但是id之不能重复
		$("#remarkDivList").on("click","a[name='deleteA']",function () { // 通过属性来进行过滤a标签
			// 收集参数
			let id = $(this).attr("remarkId") // 通过this来进行选择, 然后通过attr来获取数据 如果不是value属性就需要通过attr属性来获取属性
			// 发送请求
			$.ajax({
				url:'workbench/activity/deleteActivityRemarkById.do',
				data:{
					id:id
				},
				type:'post',
				dataType: 'json',
				// 执行回调函数
				success:function (data) {
				if (data.code=="1"){
					// 刷新列表 将数据进行删除  表达式。
					$("#div_"+id).remove(); // 从浏览器删除元素。
				}else {
					alert(data.message);
				}
				}

			});

		});

		// 给修改按钮添加单击事件 通过on事件来添加 因为修改和删除都是动态生成的
		// 修改第一步
		$("#remarkDivList").on("click","a[name='editA']",function () {
			// 收集参数
			let id = $(this).attr("remarkId");// 如果是 获取标签属性的value的值，我们需要通过val来获得，但是如果我们需要获得别的属性的值只能通过attr来获得
			// 使用父子选择器 获取h5中的内容。
			let noteContent = $("#div_"+id+" h5").text(); // .text 获取内容
			$("#edit-id").val(id); // .val 获取value属性 或设置val属性
			$("#edit-noteContent").val(noteContent); // 将备注信息 写到窗口中
			// 弹出模态窗口
			$("#editRemarkModal").modal("show"); // modal属性 弹出模态窗口
		})
		// 修改第二步： 给更新按钮添加单击事件
		$("#updateRemarkBtn").click(function () {
			// 收集参数
			let id = $("#edit-id").val();// 如果是 获取标签属性的value的值，我们需要通过val来获得，但是如果我们需要获得别的属性的值只能通过attr来获得
			// 使用父子选择器 获取h5中的内容。
			let noteContent = $.trim($("#edit-noteContent").val()); // .text 获取内容
			// 进行表单验证
			if (noteContent==""){
				alert("备注内容不能为空")
				return;
			}
			// 通过ajax 来向后台发送数据
			$.ajax({
				url:'workbench/activity/saveEditActivityRemark.do',
				data:{
					id:id,
					noteContent:noteContent
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if (data.code=="1"){
						$("#editRemarkModal").modal("hide"); // modal属性 关闭模态窗口
						// 刷新备注列表
						$("#div_"+data.retData.id+" h5").text(data.retData.noteContent);// 更新备注内容
						// 在js中用el表达式 必须放在引号里。
						$("#div_"+data.retData.id+" small").text(" "+data.retData.editTime+" 由${sessionScope.sessionUser.name}修改") // 修改者的名字需要从session域中取数据。
					}else {
						alert(data.message);
						$("#editRemarkModal").modal("show"); // modal属性 模态窗口不关闭
					}
				}
			});
		});

	}); // 入口函数

</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id"> <%--添加隐藏域 --%>
                        <div class="form-group">
                            <label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

    

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 当我们点击市场活动的明细的时候 我们进行查询-->
	<div id="remarkDivList" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4 >备注</h4>
		</div>

		<%--items 表示要遍历的数组 var 表示 变量名		--%>
		<c:forEach items="${remarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;" >
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 >${remark.noteContent}</h5>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name }</b> <small style="color: gray;"> ${remark.editFlag=='1'?remark.editTime:remark.createTime} 由${remark.editFlag=='1'?remark.editBy:remark.createBy}${remark.editFlag='1'?'修改':'创建'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="editA" remarkId = "${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteA"remarkId = "${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		<!-- 备注1 -->
		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
	<%--	<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>