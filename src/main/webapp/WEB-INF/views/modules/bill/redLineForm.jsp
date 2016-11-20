<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>警戒值表单</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp" %>
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
		<li><a href="${ctx}/bill/redline/list">警戒线设置列表</a></li>
		<li class="active"><a href="${ctx}/bill/redline/form?numId=${empty bean.bean.GUUID?'':bean.bean.GUUID}">${empty bean.bean.GUUID?"添加":"修改"}警戒值</a></li>
	</ul>
	<tags:orgmessage content="${message}"/>
	<form:form id="inputForm" modelAttribute="bean" action="${ctx}/bill/redline/save" method="post"
		class="form-horizontal">
		<form:hidden path="bean[GUUID]" />
        <table border="0" style="height:100%;width:100%">
          <tr>
             <td>
			     <div class="control-group">
				 <label class="control-label"><font color="red">*</font>执行月份:</label>
				    <div class="controls">
				    	<c:if test="${not empty bean.bean.MONTH}">
				    		<input type="text" name="bean['MONTH']" required="true" class="input-medium Wdate"  
						    value="${bean.bean['MONTH']}" readonly="true"/>
				    	</c:if>
				    	<c:if test="${empty bean.bean.MONTH}">
					    <input type="text" name="bean['MONTH']" required="true" class="input-medium Wdate"  
						    value="${bean.bean['MONTH']}" 
						    onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:false});" />
						</c:if>
					</div>
		        </div>
			</td>
             <td>
	            <div class="control-group">
					<label class="control-label"><font color="red">*</font>警戒值（元）:</label>
					<div class="controls">
						<form:input path="bean['VALUE']"  
						value="${empty bean.bean.VALUE?0.0:bean.bean.VALUE}" htmlEscape="false" 
						maxlength="10" required="true" number="true" class="input-medium"/>
					</div>
				</div>
             </td>
          </tr>
		<tr>
			<td>
				<div class="control-group">
					<label class="control-label">备注:</label>
					<div class="controls">
				       <form:textarea path="bean['REMARK']" htmlEscape="true" rows="3" maxlength="60" 
				       	class="input-xlarge area"/>
					</div>
				</div>	
			</td>
			<td>
				<div class="control-group">
					<label class="control-label">超额说明:</label>
					<div class="controls">
				       <form:textarea path="bean['EXPLAIN']" htmlEscape="true" rows="3" maxlength="60" 
				       	class="input-xlarge area"/>
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