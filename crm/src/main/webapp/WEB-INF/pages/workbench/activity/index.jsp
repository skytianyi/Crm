<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title></title>

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet">
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet">

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <%--bs_pagination--%>
 <%--   <link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>--%>

    <!--  PAGINATION plugin -->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>


    <script type="text/javascript">

        $(function () {

            //页面加载完毕后,发送异步请求获取数据
            queryActivityByCondition(1, 4);

            //点击创建按钮弹出模态窗口
            $("#createActivityBtn").click(function () {
                //在弹出模态窗口前,清除上次的数据
                //使用form对象的reset属性清除数据
                $("#createActivityForm")[0].reset();
                $("#createActivityModal").modal("show");
            });

            //点击保存按钮发送ajax
            $("#saveCreateActivityBtn").click(function () {

                var owner = $("#create-marketActivityOwner").val();
                var name = $.trim($("#create-marketActivityName").val());
                var startDate = $("#create-startDate").val();
                var endDate = $("#create-endDate").val();
                var cost = $("#create-cost").val();
                var description = $("#create-description").val();

                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }

                if (name == "") {
                    alert("名称不能为空");
                    return;
                }

                if (startDate != "" && endDate != "") {
                    if (endDate < startDate) {
                        alert("结束日期不能比开始日期小");
                        return;
                    }
                }

                var regExp = /^(([1-9]\d*)|0)$/;
                if (!regExp.test(cost)) {
                    alert("成本只能为非负整数");
                    return;
                }

                $.ajax({
                    url: "workbench/activity/saveCreateActivity.do",
                    data: {
                        "owner": owner,
                        "name": name,
                        "startDate": startDate,
                        "endDate": endDate,
                        "cost": cost,
                        "description": description
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {

                        if (resp.code == "1") {
                            $("#createActivityModal").modal("hide");
                        } else {
                            alert(resp.message);
                        }
                    },
                    error: function () {
                        alert("保存市场活动的ajax有误");
                    }
                })

            });


            //点击查询按钮触发事件
            $("#queryActivityConditionBtn").click(function () {
                queryActivityByCondition(1, $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
            });

            //日历样式
            $(".mydate").datetimepicker({
                format: "yyyy-mm-dd",
                language: "zh-CN",
                initialDate: new Date(),
                minView: "month",
                autoclose: true,
                clearBtn: true
            });

            //点击删除按钮时删除市场活动
            $("#deleteActivityBtn").click(function () {
                var checkIds = $("#tBody input[type=checkbox]:checked");
                var param = "";
                if (checkIds.length == 0) {
                    alert("每次至少删除一条市场活动");
                    return;
                }

                if (confirm("确定要进行删除吗？")) {
                    $.each(checkIds, function () {
                        param += "ids=" + this.value + "&";
                    });
                    param = param.substr(0, param.length - 1);

                    $.ajax({
                        url: "workbench/activity/deleteActivityByIds.do",
                        data: param,
                        type: "post",
                        dateType: "json",
                        success: function (resp) {
                            if (resp.code == "1") {
                                //删除成功之后,刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                                queryActivityByCondition(1, $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
                            } else {
                                alert(resp.message);
                            }
                        }
                    })
                }

            });

            //点击修改按钮
            $("#editActivityBtn").click(function () {
                var checkIds = $("#tBody input[type=checkbox]:checked");
                if (checkIds.length == 0) {
                    alert("请选择一条修改的市场活动");
                    return;
                }

                if (checkIds.length > 1) {
                    alert("每次能且只能修改一条市场活动");
                    return;
                }
                var id = checkIds[0].value;
                $.ajax({
                    url: "workbench/activity/queryActivityById.do",
                    type: "get",
                    dateType: "json",
                    data: {
                        "id": id
                    },
                    success: function (data) {
                        $("#edit-activityId").val(data.id);
                        $("#edit-activityOwner").val(data.owner);
                        $("#edit-activityName").val(data.name);
                        $("#edit-startDate").val(data.startDate);
                        $("#edit-endDate").val(data.endDate);
                        $("#edit-cost").val(data.cost);
                        $("#edit-description").val(data.description);

                        $("#editActivityModal").modal("show");
                    }
                })
            });

            //全选
            $("#qx").click(function () {
                $("#tBody input[type='checkbox']").prop("checked", this.checked);
            });

            //反选
            $("#tBody").on("click", $("input[type=checkbox]"), function () {
                $("#qx").prop("checked", $("#tBody input[type=checkbox]").length == $("#tBody input[type=checkbox]:checked").length);
            });

            //点击更新按钮
            $("#saveEditActivityBtn").click(function () {
                var id = $("#edit-activityId").val();
                var owner = $("#edit-activityOwner").val();
                var name = $("#edit-activityName").val();
                var startDate = $("#edit-startDate").val();
                var endDate = $("#edit-endDate").val();
                var cost = $("#edit-cost").val();
                var description = $("#edit-description").val();

                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                if (startDate != "" && endDate != "") {
                    if (endDate < startDate) {
                        alert("结束日期不能比开始日期小");
                        return;
                    }
                }
                var regExp = /^(([1-9]\d*)|0)$/;
                if (!regExp.test(cost)) {
                    alert("成本只能为非负整数");
                    return;
                }

                $.ajax({
                    url: "workbench/activity/saveEditActivity.do",
                    data: {
                        "id": id,
                        "owner": owner,
                        "name": name,
                        "startDate": startDate,
                        "endDate": endDate,
                        "cost": cost,
                        "description": description
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {

                        if (resp.code == "1") {
                            $("#editActivityModal").modal("hide");
                            //更新成功刷,当前页和显示条数不变
                            queryActivityByCondition($("#mypagination").bs_pagination('getOption', 'currentPage'), $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));

                        } else {
                            alert(resp.message);
                        }
                    }
                })
            });

            //批量下载
            $("#exportActivityAllBtn").click(function () {
                window.location.href = "workbench/activity/exportAllActivitys.do";
            });

            //选择下载
            $("#exportActivityXzBtn").click(function () {
                var checkIds = $("#tBody input[type=checkbox]:checked");
                var param = "";
                if (checkIds.length == 0) {
                    alert("至少选择一条市场活动进行下载");
                    return;
                }

                $.each(checkIds, function () {
                    param += "ids=" + this.value + "&";
                });
                param = param.substr(0, param.length - 1);

                window.location.href = "workbench/activity/exportActivityByIds.do?" + param;
            });

            //导入数据
            $("#importActivityBtn").click(function () {
                var activityFileName = $("#activityFile").val();
                //表单验证
                var suffix = activityFileName.substr(activityFileName.lastIndexOf(".") + 1).toLowerCase();
                if (suffix != "xls") {
                    alert("只支持.xls");
                    return;
                }
                var activityFile = $("#activityFile")[0].files[0];
                if (activityFile.size > 1024 * 1024 * 5) {
                    alert("文件大小不超过5MB");
                    return;
                }

                var formData = new FormData();
                formData.append("activityFile", activityFile);

                //发送请求
                $.ajax({
                    url: "workbench/activity/importActivity.do",
                    type: "post",
                    data: formData,
                    processData: false,
                    contentType: false,
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            alert("成功导入:" + resp.data + "条数据");
                            //关闭模态窗口,刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                            $("#importActivityModal").modal("hide");
                            queryActivityByCondition(1, $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            //导入失败,提示信息,模态窗口不关闭,列表也不刷新
                            alert(resp.message);

                        }
                    }
                });

            });

        });

        function queryActivityByCondition(pageNo, pageSize) {
            var name = $("#name").val();
            var owner = $("#owner").val();
            var startDate = $("#startDate").val();
            var endDate = $("#endDate").val();
            var pageNo = pageNo;
            var pageSize = pageSize;

            $.ajax({
                url: "workbench/activity/queryActivityByCondition.do",
                data: {
                    "name": name,
                    "owner": owner,
                    "startDate": startDate,
                    "endDate": endDate,
                    "pageNo": pageNo,
                    "pageSize": pageSize
                },
                type: "post",
                dataType: "json",
                success: function (resp) {
                    var htmlStr = "";
                    $.each(resp.activityList, function (i, obj) {
                        htmlStr += "<tr class='active'>";
                        htmlStr += "<td><input type='checkbox' value='" + obj.id + "'/></td>";
                        htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?id="+obj.id+"'\">"+obj.name+"</a></td>";
                        htmlStr += "<td>" + obj.owner + "</td>";
                        htmlStr += "<td>" + obj.startDate + "</td>";
                        htmlStr += "<td>" + obj.endDate + "</td>";
                        htmlStr += "</tr>";
                    });
                    $("#tBody").html(htmlStr);

                    //计算总页数
                    var totalPages = 1;
                    if (resp.totalRows % pageSize == 0) {
                        totalPages = resp.totalRows / pageSize;
                    } else {
                        totalPages = parseInt(resp.totalRows / pageSize) + 1;
                    }
                    //当容器加载完成后,并且市场活动的所有信息也都查询返回,对容器调用工具函数
                    $("#mypagination").bs_pagination({
                        currentPage: pageNo,//当前页
                        rowsPerPage: pageSize,//每页显示的条数
                        totalPages: totalPages,//总页数,必填
                        totalRows: resp.totalRows,//总条数

                        visiblePageLinks: 5,

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,

                        onChangePage: function (event, obj) { // returns page_num and rows_per_page after a link has clicked
                            queryActivityByCondition(obj.currentPage, obj.rowsPerPage);

                            //只要改变就将全选的按钮取消
                            $("#qx").prop("checked", false);
                        }
                    })
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

                <form class="form-horizontal" role="form" id="createActivityForm">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                                <c:forEach items="${userList}" var="u">
                                    <option value="${u.id}">${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" readonly id="create-startDate">
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" readonly id="create-endDate">
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
                <button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
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
                    <input type="hidden" id="edit-activityId">
                    <div class="form-group">
                        <label for="edit-activityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-activityOwner">
                                <c:forEach items="${userList}" var="u">
                                    <option value="${u.id}">${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-activityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-activityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="edit-startDate" value="2020-10-10">
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="edit-endDate" value="2020-10-20">
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
                    请选择要上传的文件：
                    <small style="color: gray;">[仅支持.xls]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
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
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control mydate" type="text" id="startDate"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control mydate" type="text" id="endDate">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryActivityConditionBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createActivityBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editActivityBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
                </button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--<tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>--%>
                </tbody>
            </table>
            <div id="mypagination"></div>
        </div>

        <%--<div style="height: 50px; position: relative;top: 30px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        10
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="#">20</a></li>
                        <li><a href="#">30</a></li>
                    </ul>
                </div>
                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">首页</a></li>
                        <li class="disabled"><a href="#">上一页</a></li>
                        <li class="active"><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">下一页</a></li>
                        <li class="disabled"><a href="#">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>--%>

    </div>

</div>
</body>
</html>