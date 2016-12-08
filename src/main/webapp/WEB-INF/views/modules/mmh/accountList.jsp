<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>站点登录信息列表</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {
		if('${message}'){
			layer.msg('${message}');
		}
	});
function page(n, s) {
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").attr("action", "${ctx}/mmh/account/list");
	$("#searchForm").submit();
	return false;
}
function reload() {
	$("#searchForm input[type='text']:not(:hidden)").val("");
	$("#searchForm").submit();
}
function modify(guid){
	window.location.href="${ctx}/mmh/account/form?id="+guid;
}
function del(guid){
	top.$.jBox.confirm("确认删除站点登录信息吗？",'系统提示',function(v,h,f){
		   if(v=='ok'){
	    		$("#searchForm").attr("action","${ctx}/mmh/account/delete?id="+guid);
	    		$("#searchForm").submit();
		   }
		},{buttonsFocus:1});
 	top.$('.jbox-body .jbox-icon').css('top','55px');
}

function add() {
	window.location.href="${ctx}/mmh/account/form?siteId="+$("#siteId").val();
}
function viewPwd(id){
	$.ajax({
		type: "POST",
		dataType: "text",
		data: {"id" : id},
		url:"${ctx}/mmh/account/getInfo",
		success : function(data){
			layer.tips(data, "#"+id,{time:2500});
		}
	});
}
</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/mmh/account/list">
		<input id="siteId" name="bean['SITE_ID']" type="hidden" value="${map.bean.SITE_ID}" />
		<table border="0">
			<tr>
				<td><label>关联手机：</label></td>
				<td><form:input path="bean['CON_PHONE']" htmlEscape="false"
						maxlength="32" class="input-small" /></td>
				<td><label>关联邮箱：</label> </td>
				<td><form:input path="bean['CON_EMAIL']" htmlEscape="false"
						maxlength="32" class="input-small" />
				</td>
				<td><label>名称：</label></td>
				<td><form:input path="bean['ACCOUNT']" htmlEscape="false"
						maxlength="32" class="input-small" /></td>
				
			</tr>
			<tr>
				<td colspan="6" align="right">
					<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"
						onclick="return page();">
					&nbsp;&nbsp;<input id="btnCancel" class="btn btn-primary" type="button" value="重置"
						onclick="return reload();" />
					&nbsp;&nbsp;<input id="btnAdd" class="btn btn-primary" type="button" value="添加"
						onclick="add();" />
				</td>
			</tr>
		</table>
	</form:form>
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="120px">用户名</th>
				<th>关联手机</th>
				<th>关联邮箱</th>
				<th>创建时间</th>
				<th>备注</th>
				<th width="200px">操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${accountList}" var="bean">
				<tr>
				<td>${bean['ACCOUNT']}</td>
				<td>${bean['CON_PHONE']}</td>
				<td>${bean['CON_EMAIL']}</td>
				<td>${fns:formatDate(bean['CREATE_TIME'], 'yyyy-MM-dd HH:mm:ss') }</td>
				<td title="${bean['REMARK']}">${fn:substring(bean['REMARK'],0,10)}</td>
				<td><a href="javascript:modify('${bean.ID}')">修改</a>
				&nbsp;|&nbsp;<a href="javascript:del('${bean.ID}')">删除</a>
				&nbsp;<a id="${bean.ID}" href="javascript:viewPwd('${bean.ID}')" title="查看密码">
					<i id="iconIcon" class="icon-info-sign"></i></a>
				</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>