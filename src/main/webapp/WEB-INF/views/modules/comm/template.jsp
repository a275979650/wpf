<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>模板导出</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#tableHead").click(function () {
		    	$("#contentTable input[name='rowSelect']").prop("checked",$(this).prop("checked"));  
			});
		});
	</script>
</head>
<body>
	<div>
		<font color="red"></font>
		<table id="contentTable" class="table table-striped table-bordered table-condensed table-hover">
			<thead>
				<tr>
					<th width="12px"><input type="checkbox" id="tableHead"></th>
					<th>导出字段名称</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${fields}" var="entity" >
				<tr>
					<td>
					<c:choose>
						<c:when test="${entity.REQUIRED == '1'}">
							<input type="checkbox" name="select" checked="checked" disabled="disabled" 
							value="${entity.FIELD_ID}" /></td>
						</c:when>
						<c:otherwise>
							<input type="checkbox" name="rowSelect" value="${entity.FIELD_ID}" /></td>
							<!-- 非必填项，默认就不要勾选
							<input type="checkbox" name="rowSelect" checked="checked" value="${entity.FIELD_ID}" /></td>
							 -->
						</c:otherwise>
					</c:choose>
					<td>${entity.FIELD_NAME}</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
		<br>
	</div>
</body>
</html>