<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>站点表单</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {
		$("#inputForm").validate({rules:{
		},submitHandler:function(form) {
				loading('正在提交，请稍等...');
				form.submit();		
		},errorPlacement: function(error, element) {
		        if ( element.is(".btn") ) error.appendTo( element.parent() );			      
		        else error.appendTo( element.parent());
		}
		});
	});
	function cancel(){
		window.location.href = "${ctx}/mmh/site/list";
	}
</script>
</head>
<body>
	<div style="display:none;"><tags:orgmessage content="${message}"/></div>
	<form:form id="inputForm" modelAttribute="bean" action="${ctx}/mmh/site/save" method="post"
		class="form-horizontal">
		<form:hidden path="bean[ID]" />
        <table border="0" style="height:100%;width:100%">
          <tr>
         	<td>
	            <div class="control-group">
					<label class="control-label"><font color="red">*</font>站点类型:</label>
					<div class="controls">
						<form:select id="TYPE" path="bean['TYPE']" class="input-medium">
							<form:options items="${fns:getDictList('MMH_SITE_TYPE')}" 
							itemValue="value" itemLabel="label" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
             </td>
         	 <td>
				<div class="control-group">
					<label class="control-label">分类标签:</label>
						<div class="controls">
							<form:select id="LABEL" path="bean['TAGLIB']" class="input-medium">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('MMH_SITE_FLAG')}" 
									itemValue="value" itemLabel="label" htmlEscape="false"/>
							</form:select>
						</div>
				</div>
			</td>
		</tr>
		<tr>
             <td>
	            <div class="control-group">
					<label class="control-label"><font color="red">*</font>名称:</label>
					<div class="controls">
						<form:input id="NAME" path="bean['NAME']" htmlEscape="false" 
						maxlength="100" required="true" class="input-medium"/>
					</div>
				</div>
             </td>
             <td>
	            <div class="control-group">
					<label class="control-label"><font color="red">*</font>URL:</label>
					<div class="controls">
						<form:input id="URL" path="bean['URL']" htmlEscape="false" 
						maxlength="100" required="true" class="input-medium"/>
					</div>
				</div>
             </td>
          </tr>
		<tr>
			<td colspan="2">
				<div class="control-group">
					<label class="control-label">简介:</label>
					<div class="controls">
				       <form:textarea path="bean['EXPLAIN']" htmlEscape="true" rows="3" maxlength="60" 
				       	class="input-xlarge area" style="width:80%"/>
					</div>
				</div>	
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div class="control-group">
					<label class="control-label">备注:</label>
					<div class="controls">
				       <form:textarea path="bean['REMARK']" htmlEscape="true" rows="3" maxlength="60" 
				       	class="input-xlarge area" style="width:80%"/>
					</div>
				</div>	
			</td>
		</tr>
	</table>
	<!-- <div class="form-actions">
		<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存" />&nbsp; 
		<input id="btnCancel" class="btn" type="button" value="返 回" onclick="cancel()" />
	</div> -->
	</form:form>
</body>
</html>