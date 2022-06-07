<%@ page contentType="text/html; charset=UTF-8" language="java" %>、
<%--添加jstl标签库--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--动态获取访问地址--%>
<% String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";%>

<html>
<head>
	<base href="<%=basePath%>">	
<meta charset="UTF-8">
<%--引入css样式--%>
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script> <%--引入jquery框架--%>
<script type="text/javascript"  src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script> <%--引入bootstrap框架--%>
<%--引入日期插件--%>
<script type="text/javascript" src = "jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src = "jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!--  引入分页插件 -->
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script><%--语言包--%>

<script type="text/javascript">

	$(function(){
		$("#CreateActivityBtn").click(function () {
			// 在弹出来模态窗口之前进行初始化工作
			// 将模态窗口中的数据进行清空  $("#createActivityFrom").get(0) 获得其form表单的dom对象。然后通过reset() 将其表单清空。
			$("#createActivityFrom").get(0).reset();
			// 弹出模态窗口
			$("#createActivityModal").modal("show"); // 弹出模态窗口
		});


		//  当我们点击保存的时候 进行提交请求   保存功能
		$("#SaveCreateActivityBtn").click(function () {
			// 获取数据 从请求页面收集参数
			let owner = $("#create-marketActivityOwner").val(); // 获取保存者
			let name = $.trim($("#create-marketActivityName").val()); // 获取创建者的名称
			let startDate = $("#create-startDate").val(); // 获取开始日期
			let endDate = $("#create-endDate").val() ;// 获取结束日期
			let cost = $.trim($("#create-cost").val()); // 获取成本
			let description = $.trim($("#create-description").val()); // 获取描述


			//进行表单验证 根据需求来进行表单验证  可以将这段代码进行封装
			if (owner==""||name==""){  // 保存着和创建者的名字不能为空
				alert("保存者 或 名称不能为空！");
				return;
			}
			// 根据需求,开始日期和结束日期不可以为空且结束日期要比开始日期大
			if (startDate!=""&&endDate!=""){ //开始日期或者结束日期可以为空
				// 判断结束日期是否大于开始日期
				if (endDate<startDate){  // 在js中两个任意类型都可以进行比较
					alert("结束日期不能小于开始日期！");
					return;

				}
			}

			// 根据需求, 成本只能是非负整数 那么我们需要 通过正则表达式来进行判断
			let resExp = /^[1-9]\d*$/; // 创建正则表达式

			if (!resExp.test(cost)){  	// .test 表示匹配字符串
				alert("成本只能为非负整数");
				return;
			}
				// 收集参数之后, 我们发送异步请求
				$.ajax({
					url : 'workbench/activity/saveCreateActivity.do',
					data : {
						// 提交的参数都是页面收集好了的参数
						owner : owner, 	// 收集者的名字
						name : name, 	// 订单的名字
						startDate : startDate, // 开始日期
						endDate : endDate, // 结束日期
						cost : cost, // 成本
						description : description // 描述
					},
					type : 'post',
					dataType : 'json',
					// 构建成功  通过构建函数来提交响应
					success : function (data) { // 接收后台相应信息。 data就是returnObject
						if (data.code=="1"){ // 判断数据的标志位 如果标志位为 1 那么表示数据创建成功
							$("#createActivityModal").modal("hide"); // 数据构建成功 hide表示模态窗口关闭
							// 刷新窗口列表,将新添加的信息显示到第一列。
							queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
						}else {
							alert(data.message); // 提示信息。
							// 窗口不关闭
							$("#createActivityModal").modal("show");
						}

					}
				});
		});

		// 构建日期，使用日历插件
		/*通过类选择器 class 不只有一个值 中间用空格隔开,还可以通过组合选择器等等。*/
		$(".mydate").datetimepicker({
			language : 'zh-CN', //语言格式
			format : 'yyyy-mm-dd', // 日期的格式
			minView : 'month', // 可以选择的最小视图
			initialDate : new Date(), // 初始化显示的日期
			autoclose : true, // 设置日期选择完成之后呢，是否自动关闭日期
			todayBtn : true, // 是否显示今天按钮,默认是false
			clearBtn : true // 是否显示清空按钮,默认是 false 不显示
		});

		//当市场活动主页面加载完成，查询所有数据的第一页以及所有数据的总条数,默认每页显示10条
		queryActivityByConditionForPage(1,10);

		//给"查询"按钮添加单击事件
		$("#queryActivityBtn").click(function () {

			//查询所有符合条件数据的第一页以及所有符合条件数据的总条数;
			queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
		});
		// 给全选按钮添加单击事件。checkAll  通过id选择器来选择
		$("#checkAll").click(function () {
			// 我们判断 他的checked属性是否被选中了，如果选中了，那么就让其他属性也跟着被选中
			/*if (this.checked==true){
				// 通过父子选择器来选择子标签
				// $("#tBody">input[type='checkbox']")  > 表示只能直接选取子标签
				// $("#tBody" input[type='checkbox']")  空格 表示可以直接选取子标签也可以间接选取子标签。
				$("#tBody input[type='checkbox']").prop('checked',true);
			}else {
				$("#tBody input[type='checkbox']").prop('checked',false);
			}*/

			// 将 全选按钮和子标签中选的按钮绑定了
			$("#tBody input[type='checkbox']").prop('checked',this.checked);
		});
		// 选中按钮
		$("#tBody").on("click","input[type='checkbox']",function () {
			if ($("#tBody input[type='checkbox']").size() == $("#tBody input[type='checkbox']:checked").size()){
				// 如果别的全部选中，全选按钮也必须选中。
				$("#checkAll").prop('checked',true);
			}else {
				// 至少有一个没有选中的情况下，全选按钮也不用勾选
				$("#checkAll").prop('checked',false);
			}
		});

		// 给删除按钮 添加单击事件 函数就干两件事儿，第一件事儿 收集参数，第二件事儿 发请求
		$("#deleteActivityBtn").click(function () {
			// 收集参数  获取列表中所有被选中的checkbox
			// 在这里判断选中了那几条数据进行删除
			var checkedIds = $("#tBody input[type='checkbox']:checked"); // 这样表示选中了  是个数组
			if (checkedIds.size()==0){ // 获取数组长度
				alert("请选择要删除的市场活动");
				return;
			}
			// 判断是否删除  window.confirm 弹出一个对话框。
			if (window.confirm("确定删除吗？")){
				// 遍历选中的按钮然后获取值进行字符串的拼接
				let ids = "";
				// 要进行遍历  不遍历 传入遍历参数 你玩尼玛呢？？
				$.each(checkedIds,function () {
					// 进行字符产的拼接
					ids+="id="+this.value+"&";
				});
				ids = ids.substr(0,ids.length-1); // 进行字符串的截取
				// 将这些选中的数据通过ajax进行异步发送
				$.ajax({
					url:'workbench/activity/deleteActivityIds.do',
					data: ids,
					type:'post',
					resultType : 'json',
					// 回调函数
					success:function (data) {
						if (data.code=='1'){
							// 如果成功了再次刷新一遍 也就是在查一遍。
							queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
						}else {
							alert(data.message);// 如果删除失败 我们进行提示信息。
						}
					}
				});
			}

		});

		// 给修改按钮添加单击事件
		$("#updateActivityBtn").click(function () {
			// 收集参数 收集id  获取选中的按钮的id "$("#tBody input[type='checkbox']:checked")" 表示被选中的按钮。
			var chkedId = $("#tBody input[type='checkbox']:checked");

			if (chkedId.size()==0){ // 表示一个都没选中
				alert("请选择需要修改的市场活动");
				return;
			}else if (chkedId.size()>1){
				alert("每次只能修改一条数据");
				return;
			}

				// 获取选中的按钮的值，其按钮的值就是id值
				// var id = chkedId.get(0).value; get(0) 表示获得dom对象。
				// var id = chkedId[0].value; get(0) 表示获得dom对象。\
				var id = chkedId[0].value;
				// 获取到id值之后,我们需要进行 ajax请求
				$.ajax({
					url:'workbench/activity/queryActivityById.do',
					data:{
						id:id
					},
					type:'post',
					resultType: 'json',
					// 回调函数
					success:function (data) {
						// 把市场活动的信息显示在模态窗口上，弹出模态窗口
						$("#edit-id").val(data.id);
						$("#edit-marketActivityOwner").val(data.owner);
						$("#edit-marketActivityName").val(data.name);
						$("#edit-startTime").val(data.startDate);
						$("#edit-endTime").val(data.endDate);
						$("#edit-cost").val(data.cost);
						$("#edit-description").val(data.description);
						// 弹出模态窗口。
						$("#editActivityModal").modal("show"); // 弹出模态窗口
					}

				});

		});
		// 修改第二步： 给更新按钮添加单击事件
		$("#saveEditActivityBtn").click(function () {
			//   收集参数
			let  id = $("#edit-id").val();
			let owner = $("#edit-marketActivityOwner").val();
			let name = $.trim($("#edit-marketActivityName").val());
			let startDate = $("#edit-startTime").val();
			let endDate = $("#edit-endTime").val();
			let cost = $.trim($("#edit-cost").val());
			let description = $.trim($("#edit-description").val());
			// 调用函数进行验证
			//进行表单验证 根据需求来进行表单验证
			if (owner==""||name==""){  // 保存着和创建者的名字不能为空
				alert("保存者 或 名称不能为空！");
				return;
			}
			// 根据需求,开始日期和结束日期不可以为空且结束日期要比开始日期大
			if (startDate!=""&&endDate!=""){ //开始日期或者结束日期可以为空
				// 判断结束日期是否大于开始日期
				if (endDate<startDate){  // 在js中两个任意类型都可以进行比较
					alert("结束日期不能小于开始日期！");
					return;

				}
			}
			// 根据需求, 成本只能是非负整数 那么我们需要 通过正则表达式来进行判断
			let resExp = /^[1-9]\d*$/; // 创建正则表达式

			if (!resExp.test(cost)){  	// .test 表示匹配字符串
				alert("成本只能为非负整数");
				return;
			}

			// 如果通过之后 发出ajax请求
			$.ajax({
				url:'workbench/activity/saveEditActivity.do' ,
				data:{
					id:id,
					owner :owner,
					name :name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				type:'post',
				resultType:'json',
				success:function (data) {
					if (data.code=='1'){ // 如果为1的话 更新成功
						// 关闭模态窗口
						$("#editActivityModal").modal("hide");
						// 需求说还需要刷新页面 保持页号和显示条数不变。
						queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						alert(data.message);
						// 模态窗口不关闭
						$("#editActivityModal").modal("show");
					}
				}
			});
		});

		// 导出 市场活动
		$("#exportActivityAllBtn").click(function () {
			// 当我们点击 导出市场活动的按钮的时候 我们通过同步请求 来向后台发出请求。
			window.location.href="workbench/activity/exportAllActivitys.do";
		});

		// 选择导出市场活动
		$("#exportActivityXzBtn").click(function () {
			// 在这里判断选中了那几条数据进行导出
			var chkedId = $("#tBody input[type='checkbox']:checked");

			if (chkedId.size()==0){ // 获取数组长度
				alert("请选择要导出的市场活动");
				return;
			}

			let ids = "";
			// 要进行遍历  不遍历 传入遍历参数 你玩尼玛呢？？
			$.each(chkedId,function () {
				// 进行字符产的拼接
				ids+="id="+this.value+"&";
			});
			ids = ids.substr(0,ids.length-1); // 进行字符串的截取
			// 这里我想附带参数进行传入到controller层进行获取怎么搞？

			window.location.href="workbench/activity/queryCheckedActivity.do?"+ids;


		});

		//给"导入"按钮添加单击事件
		$("#importActivityBtn").click(function () {
			//收集参数
			var activityFileName=$("#activityFile").val();
			var suffix=activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLocaleLowerCase();//xls,XLS,Xls,xLs,....
			if(suffix!="xls"){
				alert("只支持xls文件");
				return;
			}
			var activityFile=$("#activityFile")[0].files[0];
			if(activityFile.size>5*1024*1024){
				alert("文件大小不超过5MB");
				return;
			}

			//FormData是ajax提供的接口,可以模拟键值对向后台提交参数;
			//FormData最大的优势是不但能提交文本数据，还能提交二进制数据
			var formData=new FormData();
			formData.append("activityFile",activityFile);
			formData.append("userName","张三");

			//发送请求
			$.ajax({
				url:'workbench/activity/importActivity.do',
				data:formData,
				processData:false,//设置ajax向后台提交参数之前，是否把参数统一转换成字符串：true--是,false--不是,默认是true
				contentType:false,//设置ajax向后台提交参数之前，是否把所有的参数统一按urlencoded编码：true--是,false--不是，默认是true
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//提示成功导入记录条数
						alert("成功导入"+data.retData+"条记录");
						//关闭模态窗口
						$("#importActivityModal").modal("hide");
						//刷新市场活动列表,显示第一页数据,保持每页显示条数不变
						queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#importActivityModal").modal("show");
					}
				}
			});

	});

	}); // 入口函数

	// 构建一个函数，用来进行订单名字，构建着 开始日期，结束日期 的值的获取
	function queryActivityByConditionForPage(pageNo,pageSize) {
		//收集参数
		let name=$("#query-name").val();
		let owner=$("#query-owner").val();
		let startDate=$("#query-startDate").val();
		let endDate=$("#query-endDate").val();

		//发送请求
		$.ajax({
			url:'workbench/activity/queryActivityByConditionForPage.do',
			data:{
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type:'post',
			dataType:'json',
			// 回调函数
			success:function (data) {
				//显示总条数 没有使用插件以前
				//$("#totalRowsB").text(data.totalRows);
				//遍历activityList，拼接所有行数据
				let htmlStr="";
				$.each(data.activityList,function (index,obj) {
					htmlStr+="<tr class=\"active\">";
					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/queryActivityForDetail.do?id="+obj.id+"'\">"+obj.name+"</a></td>";
					htmlStr+="<td>"+obj.owner+"</td>";
					htmlStr+="<td>"+obj.startDate+"</td>";
					htmlStr+="<td>"+obj.endDate+"</td>";
					htmlStr+="</tr>";
				});
				$("#tBody").html(htmlStr); // 标签选择器,选中之后进行显示。

				// 取消全选按钮  这里是查询完毕了,在这里将取消全选按钮。
				$("#checkAll").prop("checked",false);
				// 计算总页数
				var totalPages = 1;
					totalPages = data.totalRows%pageSize==0? data.totalRows/pageSize : (parseInt(data.totalRows/pageSize)+1);
				//对容器调用bs_pagination工具函数，显示翻页信息
					$("#demo_pag1").bs_pagination({
						currentPage:pageNo,//当前页号,相当于pageNo
						rowsPerPage:pageSize,//每页显示条数,相当于pageSize
						totalRows:data.totalRows,//总条数
						totalPages: totalPages,  //总页数,必填参数.
						visiblePageLinks:5,//最多可以显示的卡片数
						showGoToPage:true,//是否显示"跳转到"部分,默认true--显示
						showRowsPerPage:true,//是否显示"每页显示条数"部分。默认true--显示
						showRowsInfo:true,//是否显示记录的信息，默认true--显示

						// 每次翻页之后，触发翻页事件
						// 日历插件自带的函数。
						onChangePage:function (event,pageObj) {
							//alert(pageObj.currentPage),
							//alert(pageObj.rowsPerPage)
							queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
						}

					});
			}
		});

	}


</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="createActivityFrom">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label" >所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								<%--
								items 表示的是循环体，我们通过el表达式 userList是controller层中的集合名称
								var = 表示的是我们设置要遍历取出的创建的对象。
								option 表示的是 显示信息
								value 表示通过 u.id 来获取， 获取的的是名字 u.name
								--%>
								 <c:forEach items="${userList}" var="u">
									 <option value="${u.id}">${u.name}</option>
								 </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label" >开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label" >结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="SaveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<%--加一个隐藏域--%>
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
						<%--文件形式--%>
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >结束日期</div>
					  <input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<%--data-toggle="modal" data-target="#editActivityModal" 前端弹出模态窗口的方式--%>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="CreateActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateActivityBtn" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteActivityBtn"> <span class="glyphicon glyphicon-minus" ></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="demo_pag1"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
<%--			</div>--%>
			
		</div>
		
	</div>
</body>
</html>