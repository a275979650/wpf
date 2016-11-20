<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>警戒线管理</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
});
function page(n, s) {
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").attr("action", "${ctx}/bill/redline/list");
	$("#searchForm").submit();
	return false;
}
function reload() {
	window.location.href = "${ctx}/bill/redline/list";
}
function modify(guid){
	window.location.href="${ctx}/bill/redline/form?numId="+guid;
}
function del(guid){
	top.$.jBox.confirm("确认删除警戒设置吗？",'系统提示',function(v,h,f){
		   if(v=='ok'){
	    		$("#searchForm").attr("action","${ctx}/bill/redline/delete?numId="+guid);
	    		$("#searchForm").submit();
		   }
		},{buttonsFocus:1});
 	top.$('.jbox-body .jbox-icon').css('top','55px');
}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/bill/redline/list">警戒线设置列表</a></li>
		<li><a href="${ctx}/bill/redline/form">添加警戒</a></li>
	</ul>
	<tags:orgmessage content="${message}" />
	<form:form id="searchForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/bill/redline/list">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<table border="0">
			<tr>
				<td><label>设置月份：</label></td>
				<td><input type="text" name="bean['MONTH']" class="input-small Wdate"  
						value="${map.bean['MONTH']}" 
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" /></td>
				<td><label>警戒值：</label> </td>
				<td><form:input path="bean['VALUE_MIN']" value="${map.bean['VALUE_MIN']}" htmlEscape="false" 
						maxlength="10" required="true" number="true" class="input-medium"/>
				</td>
				<td>--</td>
				<td><form:input path="bean['VALUE_MAX']" value="${map.bean['VALUE_MAX']}" htmlEscape="false" 
						maxlength="10" required="true" number="true" class="input-medium"/></td>
				<td>
					&nbsp;&nbsp; <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"
						onclick="return page();">
					<input id="btnCancel" class="btn btn-primary" type="button" value="重置"
						onclick="return reload();" />&nbsp;&nbsp; 
				</td>
			</tr>
		</table>
	</form:form>

	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>操作</th>
				<th>执行月份</th>
				<th>警戒值</th>
				<th>备注</th>
				<th>超限说明</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="bean">
			<tr>
				<td><a href="javascript:modify('${bean.GUUID}')">修改</a>
				&nbsp;|&nbsp;<a href="javascript:del('${bean.GUUID}')">删除</a></td>
				<td>${bean['MONTH']}</td>
				<td>${bean['VALUE']}</td>
				<td>${bean['REMARK']}</td>
				<td>${bean['EXPLAIN']}</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>