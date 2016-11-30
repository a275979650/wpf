<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>登录信息表单</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {
		$("#inputForm").validate({
			rules : {},
			submitHandler : function(form) {
				form.submit();
			},
			errorPlacement : function(error, element) {
				if (element.is(".btn"))
					error.appendTo(element.parent());
				else
					error.appendTo(element.parent());
			}
		});
	});
</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="bean"
		action="${ctx}/mmh/account/save" method="post" class="form-horizontal">
		<form:hidden path="bean[ID]" />
		<form:hidden path="bean[SITE_ID]" />
		<table border="0" style="height: 100%; width: 100%">
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label"><font color="red">*</font>用户名:</label>
						<div class="controls">
							<form:input path="bean['ACCOUNT']" htmlEscape="false"
								maxlength="100" required="true" class="input-medium" />
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label"><font color="red">*</font>密码:</label>
						<div class="controls">
							<form:password path="bean['PWD']" maxlength="100"
								required="true" class="input-medium" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">关联邮箱:</label>
						<div class="controls">
							<form:input path="bean['CON_EMAIL']" htmlEscape="false"
								maxlength="100" class="input-medium" />
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">关联手机:</label>
						<div class="controls">
							<form:input path="bean['CON_PHONE']" htmlEscape="false"
								maxlength="100" class="input-medium" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="control-group">
						<label class="control-label">关联QQ:</label>
						<div class="controls">
							<form:input path="bean['CON_QQ']" htmlEscape="false"
								maxlength="100" class="input-medium" />
						</div>
					</div>
				</td>
				<td>
					<div class="control-group">
						<label class="control-label">关联微信:</label>
						<div class="controls">
							<form:input path="bean['CON_WEIXIN']" htmlEscape="false"
								maxlength="100" class="input-medium" />
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="control-group">
						<label class="control-label">备注:</label>
						<div class="controls">
							<form:textarea path="bean['REMARK']" htmlEscape="true" rows="3"
								maxlength="60" class="input-xlarge area" style="width:80%" />
						</div>
					</div>
				</td>
			</tr>
		</table>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit"
				value="保 存" />&nbsp; <input id="btnCancel" class="btn"
				type="button" value="返 回" onclick="history.go(-1)" />
		</div>
	</form:form>
</body>
</html>