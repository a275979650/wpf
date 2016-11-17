<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>导入历史列表</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/dialog.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").attr("action","${ctx}/comm/import/history");
			$("#searchForm").submit();
	    	return false;
	    }
		function redo(importId){
			top.$.jBox.confirm('确认还原导入数据？','系统提示',function(v,h,f){
				if(v=='ok'){
					location = "${ctx}/comm/import/redo?importId="+importId;
				}
			},{buttonsFocus:1});
			top.$('.jbox-body .jbox-icon').css('top','55px');
			return false;
		}
		function cancel(){
			//$("#menuFrame", parent.document).contents().find("li:eq(0)").addClass("active");
			//$("#menuFrame", parent.document).contents().find("li:eq(1)").removeClass("active");
			window.location.href = "${ctx}/demo/list";
		}
	</script>
</head>
<body>
    <ul class="nav nav-tabs">
		<li class="active"><a>导入历史列表</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="map" action="${ctx}/comm/import/history" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
		<table><tr><td>
		<label>导入用户：</label></td><td>
			<form:input path="bean['USER_NAME']" htmlEscape="false" 
			maxlength="30" class="input-medium"/>
		</td><td>
		<label>导入时间：</label></td><td>
			<input type="text" name="bean['BEGIN_TIME']" disabled_="false"
				readonly_="readonly" maxlength="20"
				class="input-medium Wdate"
				value="${map.bean['BEGIN_TIME']}"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
		</td><td>
		<label>~</label>&nbsp;&nbsp;</td><td>
			<input type="text" name="bean['END_TIME']" disabled_="false"
				readonly_="readonly" maxlength="20"
				class="input-medium Wdate"
				value="${map.bean['END_TIME']}"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
		</td></tr><tr><td>
		<label>导入结果：</label></td><td>
    	<form:select id="postType" path="bean['SUCCESS_FLAG']" style="width:175px;">
			<form:option value="">请选择</form:option>
			<form:option value="1">成功</form:option> 
			<form:option value="0">失败</form:option> 
		</form:select>&nbsp;
    	</td><td>
    	<label>信息类型：</label></td><td>
    	<form:select id="" path="bean['DIC_ID']" style="width:175px;">
			<form:option value="">请选择</form:option>
			<form:option value="T_COMM_BASE_INFO">基本信息</form:option> 
		</form:select>&nbsp;
    	</td><td colspan="2" align="right">
    	<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();">
    	<input class="btn" type="button" value="返回" onclick="cancel();">
    </td></tr></table>
	</div>
	</form:form>
	<div style="display: none;">
	<tags:orgmessage content="${message}"/>
	</div>
	<table id="contentTable" class="table table-striped table-bordered table-condensed table-hover">
		<thead>
			<tr>
				<th>导入时间</th>
				<th>导入用户</th>
				<th>导入结果</th>
				<th>信息类型</th>
				<th>导入详细</th>
				<!--<shiro:hasPermission name="org:base:import:history:redo">-->
				<th>操作</th>
				<!--</shiro:hasPermission>-->
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="entity" >
			<tr>
				<td>${entity.IMPORT_DATE_STR}</td>
				<td>${entity.USER_NAME}</td>
				<td>${entity.SUCCESS_FLAG_NAME}</td>
				<td>${entity.DIC_ID_NAME}</td>
				<td>${entity.IMPORT_RESULT}</td>
				<!--<shiro:hasPermission name="org:base:import:history:redo">-->
				   <td>
				   <c:if test="${entity.SUCCESS_FLAG=='1' && entity.REDO_FLAG=='0'}">
				   <a href="javascript:void(0)" onclick="redo('${entity.IMPORT_ID}')">还原</a>
				   </c:if>
				   <c:if test="${entity.SUCCESS_FLAG=='1' && entity.REDO_FLAG=='1'}">
				  	已还原
				   </c:if>
				   </td>
				<!--</shiro:hasPermission>-->
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>