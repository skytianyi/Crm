<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title></title>

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <!--  bs_pagination  -->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

    <script type="text/javascript">

        $(function () {
            queryClueByCondition(1, 3);

            //点击查询按钮
            $("#searchBtn").click(function () {
                queryClueByCondition(1, $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
            });

            //点击创建按钮弹出模态窗口
            $("#createClueBtn").click(function () {

                //清除表单
                $("#createClueForm")[0].reset();

                $("#createClueModal").modal("show");

            });

            //点击保存按钮保存线索
            $("#saveCreateClueBtn").click(function () {
                var fullname = $.trim($("#create-fullname").val());
                var appellation = $("#create-appellation").val();
                var owner = $.trim($("#create-owner").val());
                var company = $.trim($("#create-company").val());
                var job = $("#create-job").val();
                var email = $("#create-email").val();
                var phone = $("#create-phone").val();
                var website = $("#create-website").val();
                var mphone = $("#create-mphone").val();
                var state = $("#create-state").val();
                var source = $("#create-source").val();
                var description = $("#create-description").val();
                var contactSummary = $("#create-contactSummary").val();
                var nextContactTime = $("#create-nextContactTime").val();
                var address = $("#create-address").val();

                //表单验证(作业)
                //所有者、公司、姓名 非空
                if (fullname == "") {
                    alert("姓名不能为空");
                    return;
                }
                if (company == "") {
                    alert("公司名称不能为空");
                    return;
                }
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }

                //下次联系时间不能小于当前时间
                var str= new Date();
                var time= str.getFullYear() + "-" + (str.getMonth() + 1) + "-" + str.getDate();

                if(nextContactTime<time){
                    alert("下次联系时间不能小于当前时间");
                    return;
                }

                //邮箱、座机、手机号、网站 符合正则表达式
                var emailRegExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                if (!emailRegExp.test(email)) {
                    alert("请输入正确的邮箱账号");
                    return;
                }

                 var phoneRegExp=/\d{3}-\d{8}|\d{4}-\d{7}/;
                 if(!phoneRegExp.test(phone)){
                     alert("请输入正确的座机号码");
                     return;
                 }
                var mphoneRegExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
                if (!mphoneRegExp.test(mphone)) {
                    alert("请输入正确的手机号码");
                    return;
                }

                var websiteRegExp=/(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/;
                if(!websiteRegExp.test(website)){
                    alert("请输入正确的网站地址");
                    return;
                }

                $.ajax({
                    url: "workbench/clue/saveCreateClue.do",
                    type: "post",
                    data: {
                        fullname: fullname,
                        appellation: appellation,
                        owner: owner,
                        company: company,
                        job: job,
                        email: email,
                        phone: phone,
                        website: website,
                        mphone: mphone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {

                            //创建成功之后，关闭模态窗口，刷新线索列表，显示第一页数据，保持每页显示条数不变
                            $("#createClueModal").modal("hide");
                            queryClueByCondition(1, $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            //创建失败，提示信息，模态窗口不关闭，列表也不刷新
                            alert(resp.message);
                        }
                    }
                })

            });

            //日历样式
            $(".mydate").datetimepicker({
                format: "yyyy-mm-d",
                language: "zh-CN",
                initialDate: new Date(),
                minView: "month",
                autoclose: true,
                clearBtn: true
            });

            //全选
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked", this.checked);
            });

            //反选
            $("#tBody").on("click", "input[name=xz]", function () {
                $("#qx").prop("checked", $("input[name=xz]:checked").length == $("input[name=xz]").length);
            });

            //点击修改按钮
            $("#updateClueBtn").click(function () {
                var $xz = $("input[name=xz]:checked");
                if ($xz.length == 0) {
                    alert("请选择要修改的记录");
                    return;
                }
                if ($xz.length > 1) {
                    alert("每次能且只能修改一条市场活动");
                    return;
                }
                var id = $xz.val();


                $.ajax({
                    url: "workbench/clue/queryClueById.do",
                    type: "get",
                    data: {
                        "id": id
                    },
                    dataType: "json",
                    success: function (resp) {

                        if (resp.code == "1") {

                            $("#hidden-clueId").val(resp.data.id);
                            $("#edit-fullname").val(resp.data.fullname);
                            $("#edit-appellation").val(resp.data.appellation);
                            $("#edit-owner").val(resp.data.owner);
                            $("#edit-company").val(resp.data.company);
                            $("#edit-job").val(resp.data.job);
                            $("#edit-email").val(resp.data.email);
                            $("#edit-phone").val(resp.data.phone);
                            $("#edit-website").val(resp.data.website);
                            $("#edit-mphone").val(resp.data.mphone);
                            $("#edit-state").val(resp.data.state);
                            $("#edit-source").val(resp.data.source);
                            $("#edit-description").val(resp.data.description);
                            $("#edit-contactSummary").val(resp.data.contactSummary);
                            $("#edit-nextContactTime").val(resp.data.nextContactTime);
                            $("#edit-address").val(resp.data.address);

                            $("#editClueModal").modal("show");
                        }
                    }
                })
            });

            //点击更新按钮
            $("#saveUpdateClueBtn").click(function () {
                var id = $("#hidden-clueId").val();
                var fullname = $.trim($("#edit-fullname").val());
                var appellation = $("#edit-appellation").val();
                var owner = $.trim($("#edit-owner").val());
                var company = $.trim($("#edit-company").val());
                var job = $("#edit-job").val();
                var email = $("#edit-email").val();
                var phone = $("#edit-phone").val();
                var website = $("#edit-website").val();
                var mphone = $("#edit-mphone").val();
                var state = $("#edit-state").val();
                var source = $("#edit-source").val();
                var description = $("#edit-description").val();
                var contactSummary = $("#edit-contactSummary").val();
                var nextContactTime = $("#edit-nextContactTime").val();
                var address = $("#edit-address").val();

                //表单验证
                //表单验证(作业)
                //所有者、公司、姓名 非空
                if (fullname == "") {
                    alert("姓名不能为空");
                    return;
                }
                if (company == "") {
                    alert("公司名称不能为空");
                    return;
                }
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }

                //下次联系时间不能小于当前时间
                var currentDate = new Date();
                var time=currentDate.toLocaleDateString().split('/').join('-');
                if(nextContactTime<time){
                    alert("下次联系时间不能小于当前时间");
                    return;
                }

                //邮箱、座机、手机号、网站 符合正则表达式
                var emailRegExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                if (!emailRegExp.test(email)) {
                    alert("请输入正确的邮箱账号");
                    return;
                }

                var mphoneRegExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
                if (!mphoneRegExp.test(mphone)) {
                    alert("请输入正确的手机号码");
                    return;
                }

                $.ajax({
                    url: "workbench/clue/updateClue.do",
                    type: "post",
                    data: {
                        id:id,
                        fullname: fullname,
                        appellation: appellation,
                        owner: owner,
                        company: company,
                        job: job,
                        email: email,
                        phone: phone,
                        website: website,
                        mphone: mphone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {

                            //更新成功之后，关闭模态窗口，刷新线索列表，显示当前页数据，保持每页显示条数不变
                            $("#editClueModal").modal("hide");
                            queryClueByCondition($("#mypagination").bs_pagination('getOption', 'currentPage'), $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
                        } else {
                            //更新失败，提示信息，模态窗口不关闭，列表也不刷新
                            alert(resp.message);
                        }
                    }
                })


            });

            //点击删除按钮
            $("#deleteClueBtn").click(function () {
                var $xz = $("input[name=xz]:checked");
                if($xz.length==0){
                    alert("每次至少删除一条市场活动");
                    return;
                }
                if(confirm("确定要删除吗?")){

                    var paramStr="";
                    for (var i = 0; i < $xz.length; i++) {
                        paramStr+="ids="+$($xz[i]).val()+"&";
                    }

                    var param= paramStr.substring(0,paramStr.length-1);

                    $.ajax({
                        url:"workbench/clue/deleteClue.do",
                        type:"post",
                        data:param,
                        dataType:"json",
                        success:function (resp) {
                            if(resp.code=="1"){
                                //删除成功之后,刷新市场活动列表,显示第一页数据,保持每页显示条数不变

                                queryClueByCondition(1, $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
                            }else {
                                alert(resp.message);
                            }
                        }
                    })
                }


            });


        });

        function queryClueByCondition(pageNo, pageSize) {
            var fullname = $("#fullname").val();
            var company = $("#company").val();
            var phone = $("#phone").val();
            var source = $("#source").val();
            var owner = $("#owner").val();
            var mphone = $("#mphone").val();
            var state = $("#state").val();
            var pageNo = pageNo;
            var pageSize = pageSize;

            $.ajax({
                url: "workbench/clue/queryClueByCondition.do",
                data: {
                    "fullname": fullname,
                    "company": company,
                    "phone": phone,
                    "source": source,
                    "owner": owner,
                    "mphone": mphone,
                    "state": state,
                    "pageNo": pageNo,
                    "pageSize": pageSize
                },
                type: "post",
                dataType: "json",
                success: function (resp) {

                    var htmlStr = "";
                    $.each(resp.clueList, function (i, obj) {
                        htmlStr += "<tr>";
                        htmlStr += "<td><input type=\"checkbox\" name='xz' value=\"" + obj.id + "\" /></td>";
                        htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detailClue.do?id="+obj.id+"'\">" + obj.fullname + obj.appellation + "</a></td>";
                        htmlStr += "<td>" + obj.company + "</td>";
                        htmlStr += "<td>" + obj.phone + "</td>";
                        htmlStr += "<td>" + obj.mphone + "</td>";
                        htmlStr += "<td>" + obj.source + "</td>";
                        htmlStr += "<td>" + obj.owner + "</td>";
                        htmlStr += "<td>" + obj.state + "</td>";
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

                    //调用工具函数,进行分页查询
                    $("#mypagination").bs_pagination({
                        currentPage: pageNo,//当前页
                        rowsPerPage: pageSize,//每页显示条数
                        totalPages: totalPages,//总页数
                        totalRows: resp.totalRows,//记录总条数

                        visiblePageLinks: 5,

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,

                        onChangePage: function (event, obj) { // returns page_num and rows_per_page after a link has clicked
                            $("#qx").prop("checked",false);
                            queryClueByCondition(obj.currentPage, obj.rowsPerPage);

                        }
                    })

                }
            })
        }

    </script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="createClueForm">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="state">
                                    <option value="${state.id}">${state.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">线索描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control mydate" id="create-nextContactTime">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id=saveCreateClueBtn>保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="hidden-clueId">
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="state">
                                    <option value="${state.id}">${state.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control mydate" id="edit-nextContactTime">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>

                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveUpdateClueBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
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
                        <input class="form-control" type="text" id="fullname">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="company">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="source">
                            <option></option>
                            <c:forEach items="${sourceList}" var="source">
                                <option value="${source.id}">${source.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="mphone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="state">
                            <option></option>
                            <c:forEach items="${clueStateList}" var="state">
                                <option value="${state.id}">${state.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" id="updateClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--	<tr>
                        <td><input type="checkbox" /></td>
                        <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                        <td>动力节点</td>
                        <td>010-84846003</td>
                        <td>12345678901</td>
                        <td>广告</td>
                        <td>zhangsan</td>
                        <td>已联系</td>
                    </tr>
                    <tr class="active">
                        <td><input type="checkbox" /></td>
                        <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                        <td>动力节点</td>
                        <td>010-84846003</td>
                        <td>12345678901</td>
                        <td>广告</td>
                        <td>zhangsan</td>
                        <td>已联系</td>
                    </tr>--%>
                </tbody>
            </table>
            <div id="mypagination"></div>
        </div>

        <%--<div style="height: 50px; position: relative;top: 60px;">
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