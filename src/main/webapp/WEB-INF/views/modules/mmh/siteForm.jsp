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
	
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/mmh/site/list">站点管理列表</a></li>
		<li class="active"><a href="${ctx}/mmh/site/form?id=${empty bean.bean.ID?'':bean.bean.ID}">
			${empty bean.bean.ID?"添加":"修改"}站点</a></li>
	</ul>
	<tags:orgmessage content="${message}"/>
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
					<label class="control-label"><font color="red">*</font>分类标签:</label>
						<div class="controls">
							<tags:treeselect id="LABEL" name="bean['LABEL']" value="${bean.bean.LABEL}" 
							labelName="bean['LABEL_NAME']" 
							labelValue="${fns:getBillLabelBySeparator(bean.bean.LABEL,'','')}" title="分类标签" 
							url="/bill/comm/treeData" extId="${bean.bean.LABEL}" cssClass="input-small"/>
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
	<div class="form-actions">
		<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存" />&nbsp; 
		<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)" />
	</div>
	</form:form>
</body>
</html>