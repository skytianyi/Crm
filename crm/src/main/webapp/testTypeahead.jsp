<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title></title>
</head>
<body>
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

<script type="text/javascript">
   $(function(){

       $('#customerName').typeahead({
           source: function (query, process) {
               $.ajax({
                   url: "workbench/contacts/getCustomerName.do",
                   type: 'get',
                   dataType: "json",
                   data:{
                       name:query
                   },
                   success: function (resp) {
                       var arr = [];
                       $.each(resp.data,function (i,obj) {
                          arr.push(obj.name)

                       });
                     
                       process(arr);
                   }
               });
           }
       });



   });

</script>

</body>
<div align="center">
    <input id="customerName" type="text" class="typeahead" autocomplete="off" />
</div>
</html>
