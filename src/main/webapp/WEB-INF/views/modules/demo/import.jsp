<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>信息导入</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/dialog.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#importForm").validate({
				submitHandler:function(form) {
					var name = $("#uploadFile").val();
					if(name == "") {
						top.$.jBox.alert('请选择文件！','提示');
						return;
					}
					var arr = name.split(".");
					var type = arr[arr.length - 1];
					if(type == "xls" || type == "xlsx" || type == "XLS" || type == "XLSX") {
						loading('正在导入，请稍等...');
						form.submit();
					} else {
						top.$.jBox.alert("请选择Excel(xls或xlsx)文件","提示");
						return false;
					}
				}
			});
			
			$("#download_btn").click(function(){
				var groupId = $("#GROUP_NUM_ID").val();
				var groupName = $("#GROUP_NUM_ID").find("option:selected").text();
				$("#template_group_id").val(groupId);
				$("#template_group_name").val(groupName);
				$("#templateForm").submit();
			});
		});
		
	</script>
</head>
<body>
<div>
	<div>
		<form:form id="templateForm" modelAttribute="bean" action="${ctx}/wage/basicSalary/import/downloadTemplate" method="post" 
			class="form-search" target="data_import_frame">
			<form:hidden id="template_group_name" path="bean['GROUP_NAME']"/>
			<form:hidden id="template_group_id" path="bean['GROUP_NUM_ID']" />
		</form:form>
		<form id="importForm" action="${ctx}/wage/basicSalary/import/importBase" method="post" enctype="multipart/form-data"
			style="padding-left:20px;" class="form-search" 
			target="data_import_frame" >
			<table style="width:100%">
				<tr>
					<td colspan="3" style="color:red;">
						注意事项：<br>
						1、请选择对应工资组模板导入，不要修改表头;<br>
						2、下载模板前请注意配置好个工资组及开启状态;<br>
                        3、模版内容请务必填写完整再上传。
					</td>
				</tr>
				<tr>
					<td>选择工资组：</td>
					<td>
						<select id="GROUP_NUM_ID" name="groupId" class="input-large" >
			               <c:forEach items="${groupList}" var="group">
			               		<option value="${group.GROUP_ID }">${group.GROUP_NAME }</option>
			               </c:forEach>
			           </select>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="download_btn" class="btnImpAndExp btn-primaryImpAndExp"  type="button" value="下载模板"/></td>
				</tr>
				<tr height="60px">
					<td>导入文件：</td>
					<td colspan="2"><input id="uploadFile" name="file" type="file" style="width:330px"/></td>
				</tr>
				<tr>
					<td colspan="3" align="center">
					<input id="btnImportSubmit" class="btnImpAndExp btn-primaryImpAndExp" 
						type="submit" value="   导    入   "/></td>
				</tr>
			</table>
		</form>
	</div>
	<iframe id="data_import_frame" name="data_import_frame" width="100%" height="120px" 
		scrolling="auto" frameborder="0"></iframe>
</div>
</body>
</html>