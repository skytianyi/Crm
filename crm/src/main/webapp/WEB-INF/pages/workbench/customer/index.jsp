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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <!--  bs_pagination  -->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

    <script type="text/javascript">

        $(function () {

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            //加载完毕后查询数据
            queryCustomerByCondition(1,2);

            //点击查询按钮进行查询
            $("#searchBtn").click(function () {
                queryCustomerByCondition(1, $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
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
                $("input[name=xz]").prop("checked",this.checked);
            });

            //反选
            $("#tBody").on("click","input[name=xz]",function () {
                $("#qx").prop("checked",$("input[name=xz]:checked").length==$("input[name=xz]").length)
            });

            //点击创建按钮时
            $("#createCustomerBtn").click(function () {

                $("#customerForm")[0].reset();
                $("#createCustomerModal").modal("show");
            });

            //点击保存按钮时
            $("#saveCreateCustomerBtn").click(function () {
                var owner=$.trim($("#create-owner").val());
                var name=$.trim($("#create-name").val());
                var website=$("#create-website").val();
                var phone=$("#create-phone").val();
                var contactSummary=$("#create-contactSummary").val();
                var nextContactTime=$("#create-nextContactTime").val();
                var description=$("#create-description").val();
                var address=$("#create-address").val();

                if(owner==''){
                    alert("所有者不能为空");
                    return;
                }
                if(name==''){
                    alert("姓名不能为空");
                    return;
                }

                var phoneRegExp=/\d{3}-\d{8}|\d{4}-\d{7}/;
                if(!phoneRegExp.test(phone)){
                    alert("请输入正确的座机号码");
                    return;
                }

                var websiteRegExp=/(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/;
                if(!websiteRegExp.test(website)){
                    alert("请输入正确的网站地址");
                    return;
                }

                //下次联系时间不能小于当前时间
                var currentDate = new Date();
                var time=currentDate.toLocaleDateString().split('/').join('-');
                if(nextContactTime<time){
                    alert("下次联系时间不能小于当前时间");
                    return;
                }

                $.ajax({
                    url:"workbench/customer/saveCreateCustomer.do",
                    type:"post",
                    data:{
                        owner:owner,
                        name:name,
                        website:website,
                        phone:phone,
                        contactSummary:contactSummary,
                        nextContactTime:nextContactTime,
                        description:description,
                        address:address
                    },
                    dataType:"json",
                    success:function (resp) {
                        if(resp.code=="1"){

                            $("#createCustomerModal").modal("hide");
                            queryCustomerByCondition(1, $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
                        }else {
                            alert(resp.message);
                        }
                    }
                })

            });



            //点击修改按钮时
            $("#editCustomerBtn").click(function () {
                var $xz = $("input[name=xz]:checked");
                if($xz.length==0){
                    alert("请选择要修改的记录");
                    return;
                }
                if($xz.length>1){
                    alert("每次能且只能修改一条市场活动");
                    return;
                }

                var id=$xz.val();
                $.ajax({
                    url:"workbench/customer/queryCustomerById.do",
                    type:"get",
                    data:{
                        id:id
                    },
                    dataType:"json",
                    success:function (resp) {
                        $("#hidden-customerId").val(id);
                        $("#edit-owner").val(resp.owner);
                        $("#edit-name").val(resp.name);
                        $("#edit-website").val(resp.website);
                        $("#edit-phone").val(resp.phone);
                        $("#edit-contactSummary").val(resp.contactSummary);
                        $("#edit-nextContactTime").val(resp.nextContactTime);
                        $("#edit-description").val(resp.description);
                        $("#edit-address").val(resp.address);
                        $("#editCustomerModal").modal("show");
                    }
                })
            });

            //点击更新按钮时
            $("#updateCustomerBtn").click(function () {
                var id = $("#hidden-customerId").val();
                var owner = $("#edit-owner").val();
                var name = $("#edit-name").val();
                var website = $("#edit-website").val();
                var phone = $("#edit-phone").val();
                var contactSummary = $("#edit-contactSummary").val();
                var nextContactTime = $("#edit-nextContactTime").val();
                var description = $("#edit-description").val();
                var address = $("#edit-address").val();
                if(owner==''){
                    alert("所有者不能为空");
                    return;
                }
                if(name==''){
                    alert("姓名不能为空");
                    return;
                }

                var phoneRegExp=/\d{3}-\d{8}|\d{4}-\d{7}/;
                if(!phoneRegExp.test(phone)){
                    alert("请输入正确的座机号码");
                    return;
                }

                var websiteRegExp=/(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?/;
                if(!websiteRegExp.test(website)){
                    alert("请输入正确的网站地址");
                    return;
                }

                //下次联系时间不能小于当前时间
                var str= new Date();
                var time= str.getFullYear() + "-" + (str.getMonth() + 1) + "-" + str.getDate();

                if(nextContactTime<time){
                    alert("下次联系时间不能小于当前时间");
                    return;
                }

                $.ajax({
                    url:"workbench/customer/updateCustomer.do",
                    type:"post",
                    data:{
                        id:id,
                        owner:owner,
                        name:name,
                        website:website,
                        phone:phone,
                        contactSummary:contactSummary,
                        nextContactTime:nextContactTime,
                        description:description,
                        address:address
                    },
                    dataType:"json",
                    success:function (resp) {
                        if(resp.code=="1"){

                            $("#editCustomerModal").modal("hide");
                            queryCustomerByCondition($("#mypagination").bs_pagination('getOption', 'currentPage'), $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
                        }else {
                            alert(resp.message);
                        }
                    }
                })

            });

            //点击删除按钮时
            $("#deleteCustomerBtn").click(function () {
                var $xz = $("input[name=xz]:checked");
                if($xz.length==0){
                    alert("请选择要删除的记录");
                    return;
                }
                if(confirm("确定要进行删除吗?")){
                    var paramStr="";
                    $.each($xz,function (i,obj) {
                        paramStr+="ids="+obj.value+"&";
                    });
                    var param=paramStr.substr(0,paramStr.length-1);

                    $.ajax({
                        url:"workbench/customer/deleteCustomerByIds.do",
                        data:param,
                        type:"post",
                        dataType:"json",
                        success:function (resp) {
                            if(resp.code=="1"){
                                //删除成功之后,刷新市场活动列表,显示第一页数据,保持每页显示条数不变

                                queryCustomerByCondition(1, $("#mypagination").bs_pagination('getOption', 'rowsPerPage'));
                            }else {
                                alert(resp.message);
                            }
                        }
                    })
                }

            });



        });

        //根据查询条件查询数据,并进行分页
        function queryCustomerByCondition(pageNo, pageSize) {
            var name = $("#name").val();
            var owner = $("#owner").val();
            var phone = $("#phone").val();
            var website = $("#website").val();
            var pageNo = pageNo;
            var pageSize = pageSize;

            $.ajax({
                url: "workbench/customer/queryCustomerByCondition.do",
                data: {
                    name: name,
                    owner: owner,
                    phone: phone,
                    website: website,
                    pageNo: pageNo,
                    pageSize: pageSize
                },
                type:"post",
                dataType:"json",
                success:function (resp) {
                    var htmlStr="";
                    $.each(resp.customerList,function (i, obj) {
                        htmlStr+="<tr>";
                        htmlStr+="<td><input type=\"checkbox\" name=\"xz\" value='"+obj.id+"'/></td>";
                        htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\"onclick=\"window.location.href='workbench/customer/detailCustomer.do?id="+obj.id+"'\">"+obj.name+"</a></td>";
                        htmlStr+="<td>"+obj.owner+"</td>";
                        htmlStr+="<td>"+obj.phone+"</td>";
                        htmlStr+="<td>"+obj.website+"</td>";
                        htmlStr+="</tr>";
                    });
                    $("#tBody").html(htmlStr);

                    var totalPages=1;
                    if(resp.totalRows%pageSize==0){
                        totalPages=resp.totalRows/pageSize;
                    }else {
                        totalPages=parseInt(resp.totalRows/pageSize)+1;
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
                            queryCustomerByCondition(obj.currentPage, obj.rowsPerPage);

                        }
                    })
                }
            });
        }

    </script>
</head>
<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="customerForm">

                    <input type="hidden" id="hidden-customerId">
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
                        <label for="create-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
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
                <button type="button" class="btn btn-primary" id="saveCreateCustomerBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">

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
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website" >
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" >
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
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
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateCustomerBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
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
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="website">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="searchBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createCustomerBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" id="editCustomerBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="tBody">
               <%-- <tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detdetail.jsp>动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detdetail.jsp>动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
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