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
		});
		function downloadTemplete(){
			top.$.jBox.open("iframe:${ctx}/comm/import/template?dicId=${param.dicId}", "模板导出", 250, 450, {
				buttons:{"下载":"ok","关闭":true},submit:function(v, h, f){
					if (v=="ok"){
						var fields = '';
						h.find("iframe").contents().find("#contentTable input[name='rowSelect']:checked").each(function(){
							fields = fields + ",'"+ $(this).val() + "'";
						});
						h.find("iframe").contents().find("#contentTable input[name='select']:checked").each(function(){
							fields = fields + ",'"+ $(this).val() + "'";
						});
						if(fields==null || fields.length == 0){
							top.$.jBox.alert('请选择记录！','提示');
							return false;
						}else{
							$("#leader_base_import_template_fields").val(fields);
							//loading('正在提交，请稍等...');//页面无刷新会导致进度不消失
							$("#templateForm").submit();
						}
					}
				},loaded:function(h){
					$(".jbox-content", top.document).css("overflow-y","hidden");
				}
			});
		}
		function importHistory(){
			//$("#menuFrame", parent.document).contents().find("li:eq(0)").removeClass("active");
			//$("#menuFrame", parent.document).contents().find("li:eq(1)").addClass("active");
			$("#mainFrame", parent.document).attr("src","${ctx}/comm/import/history");
			window.parent.window.jBox.close();
		}
	</script>
</head>
<body>
<div>
	<div>
		<form id="templateForm" action="${ctx}/comm/import/downloadTemplate" method="post" 
			class="form-search" style="display:none;" target="data_import_frame">
			<input ID="leader_base_import_template_fields" name="bean[FIELDS]">
			<input name="bean[dicId]" value="${param.dicId}" id="import_template_dic_id">
			<input name="bean[dicName]" id="import_template_dic_name">
		</form>
		<form id="importForm" action="${ctx}/comm/import/importBase" method="post" enctype="multipart/form-data"
			style="padding-left:20px;" class="form-search" 
			target="data_import_frame" >
			<input type="hidden" name="dicId" value="${param.dicId}">
			<br/>
			<table>
				<tr>
					<td colspan="3" style="color:red;">
						<%-- 注意事项：请使用系统模板导入，不要修改表头;<br>
						日期请使用“yyyy-MM”格式 字符串,或EXCEL日期;<br>
						${requiredFieldString} 请必填 。 --%>
						注意事项：<br>
						1、请使用系统模板导入，不要修改表头;<br>
						2、日期请使用“yyyy-MM”或者“yyyy-MM-dd”,格式 字符串;<br>
                        3、模版内容请务必填写完整再上传。<br>
                        <a href="javascript:void(0)" onclick="downloadTemplete()">下载模板</a>&nbsp;&nbsp;
                        &nbsp;&nbsp;<a href="javascript:void(0)" onclick="importHistory()">查看导入历史</a>
					</td>
				</tr>
				<tr height="60px">
					<td>导入文件：</td>
					<td><input id="uploadFile" name="file" type="file" style="width:330px"/></td>
					<td></td>
				</tr>
				<tr>
					<td colspan="2" align="center"><input id="btnImportSubmit" class="btnImpAndExp  btn-primaryImpAndExp" 
					type="submit" value="   导    入   "/></td>
					<td></td>
				</tr>
			</table>
		</form>
	</div>
	<iframe id="data_import_frame" name="data_import_frame" width="100%" height="120px" 
		scrolling="no" frameborder="0"></iframe>
</div>
</body>
</html>