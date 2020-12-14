<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
	<meta charset="UTF-8">
	<base href="<%=basePath%>">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script type="text/javascript">
		$(function () {

			//日历样式
			$(".mydate").datetimepicker({
				format: "yyyy-mm-dd",
				language: "zh-CN",
				initialDate: new Date(),
				minView: "month",
				autoclose: true,
				clearBtn: true
			});

			//点击市场活动源打开模态窗口
			$("#openActivitySrc").click(function () {
				$("#searchActivityTxt").val("");
				$("#tBody").html("");
				$("#findMarketActivity").modal("show");
			});

			//市场活动名称模糊查询
			$("#searchActivityTxt").keyup(function () {
				var name = this.value;

				$.ajax({
					url:"workbench/transaction/getActivityByName.do",
					data:{
						name:name
					},
					type:"post",
					dataType:"json",
					success:function (resp) {
						var htmlStr="";
						$.each(resp,function (i,obj) {
								htmlStr+="<tr>";
								htmlStr+="<td><input type=\"radio\" name=\"activity\" activityName=\""+obj.name+"\" value=\""+obj.id+"\"/></td>";
									htmlStr+="<td>"+obj.name+"</td>";
									htmlStr+="<td>"+obj.startDate+"</td>";
									htmlStr+="<td>"+obj.endDate+"</td>";
									htmlStr+="<td>"+obj.owner+"</td>";
									htmlStr+="</tr>";
						});
						$("#tBody").html(htmlStr);
					}
				})
			});

			//分别给市场活动源绑定事件
			$("#tBody").on("click","input[name=activity]",function () {
				var activityId = this.value;
				var name = $(this).attr("activityName");
				$("#create-activitySrc").val(name);
				$("#hidden-activitySrc").val(activityId);
				$("#findMarketActivity").modal("hide");
			});


			//点击联系人名称打开模态窗口
			$("#openContactsName").click(function () {
				$("#searchContactsTxt").val("");
				$("#contactsTBody").html("");
				$("#findContacts").modal("show");
			});

			//联系人模糊查询
			$("#searchContactsTxt").keyup(function () {
				var name = this.value;

				$.ajax({
					url:"workbench/transaction/getContactsByName.do",
					data:{
						name:name
					},
					type:"post",
					dataType:"json",
					success:function (resp) {
						var htmlStr="";
						$.each(resp,function (i,obj) {
							htmlStr+="<tr>";
							htmlStr+="<td><input type=\"radio\" name=\"contacts\" contactsName=\""+obj.fullname+"\" value=\""+obj.id+"\"/></td>";
							htmlStr+="<td>"+obj.fullname+"</td>";
							htmlStr+="<td>"+obj.email+"</td>";
							htmlStr+="<td>"+obj.mphone+"</td>";
							htmlStr+="</tr>";
						});
						$("#contactsTBody").html(htmlStr);
					}
				})
			});

			//分别给联系人绑定事件
			$("#contactsTBody").on("click","input[name=contacts]",function () {
				var contactsId = this.value;
				var name = $(this).attr("contactsName");
				$("#create-contactsName").val(name);
				$("#hidden-contactsName").val(contactsId);
				$("#findContacts").modal("hide");
			});

			//给阶段下拉框添加changge事件
			$("#create-transactionStage").change(function () {
				var stage=$("#create-transactionStage>option:selected").text();
				if(stage==""){
					//清空可能性
					$("#create-possibility").val("");
					return;
				}
				$.ajax({
					url:"workbench/transaction/getPossibility.do",
					data:{
						stage:stage
					},
					type:"post",
					dataType:"json",
					success:function (resp) {
						$("#create-possibility").val(resp);
					}
				})
			});

			//客户名称自动补全
			$('#create-accountName').typeahead({
				source: function (query, process) {
					/*用户在容器中输入关键字，每次键盘弹起，都会自动触发该函数；
					可以在函数中向后台发送异步请求，查询客户名称，以字符串数组([])的形式返回到客户端；
					把该响应信息赋值给source参数，从而实现自动补全。*/

					//query参数：每次键盘弹起时，容器中已经输入的关键字
					//process参数：是一个函数，作用是把[]json字符串赋值给source。
					//向后台发送异步请求，查询客户名称
					$.ajax({
						url: "workbench/transaction/getCustomerName.do",
						type: 'get',
						dataType: "json",
						data:{
							name:query
						},
						success: function (data) {

							/*此方法是返回对象时，遍历对象取值，在放入数组
							var arr = [];
							$.each(resp,function (i,obj) {
								arr.push(obj.name)

							});*/

							process(data);
						}
					});
				}
			});






		});
	</script>

</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="searchActivityTxt" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="tBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="searchContactsTxt" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsTBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
				 <c:forEach items="${userList}" var="user">
                     <option value="${user.id}">${user.name}</option>
                 </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control mydate" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建" autocomplete="off">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
			   <c:forEach items="${stageList}" var="stage">
                   <option value="${stage.id}">${stage.value}</option>
               </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
				  <c:forEach items="${typeList}" var="type">
                      <option value="${type.id}">${type.value}</option>
                  </c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
				  <c:forEach items="${sourceList}" var="source">
                      <option value="${source.id}">${source.value}</option>
                  </c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openActivitySrc"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activitySrc" readonly>
				<input type="hidden" id="hidden-activitySrc">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="openContactsName"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsName" readonly>
				<input type="hidden" id="hidden-contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control mydate" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>