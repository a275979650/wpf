<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>账单详情</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		
	});
</script>
</head>
<body><br>
<form:form id="inputForm" modelAttribute="bean" action="" method="post"
		class="form-horizontal" >
	<table style="height:100%;width:100%">
		<tr>
         <td>
                <div class="control-group">
	      <label class="control-label"><font color="red">*</font><strong>账单主体:</strong></label>
	      <div class="controls">${bean.BLONG_NAME}</div>
	      </div>
             </td>
             <td>
			     <div class="control-group">
				 <label class="control-label"><font color="red">*</font><strong>账单时间:</strong></label>
				    <div class="controls">
					    ${fns:formatDate(bean['CONSUME_TIME'], 'yyyy-MM-dd HH:mm:ss') }
					</div>
		        </div>
			</td>
          </tr>
          <tr>		  
	        <td>
	            <div class="control-group">
					<label class="control-label"><font color="red">*</font><strong>收支类型:</strong></label>
					<div class="controls">
						${fns:getDictLabel(bean['CONSUME_TYPE'], 'BILL_IN_OUT_TYPE', '')}
					</div>
				</div>
             </td>
             <td>
	            <div class="control-group">
					<label class="control-label"><font color="red">*</font><strong>金额（元）:</strong></label>
					<div class="controls">
						${bean.AMOUNT}
					</div>
				</div>
             </td>
          </tr>
          <tr>
			<td>
				<div class="control-group">
					<label class="control-label"><font color="red">*</font><strong>分类标签:</strong></label>
						<div class="controls">
							${fns:getBillLabelBySeparator(bean.LABEL,'','')}
						</div>
				</div>
			</td>
			<td>
			        <div class="control-group">
					<label class="control-label"><font color="red">*</font><strong>资金来源:</strong></label>
					<div class="controls">
						${fns:getDictLabel(bean['PAY_WAY'], 'BILL_PAY_WAY', '')}
					</div>
		           </div>
	       </td>
		</tr>
		<tr>
			<td colspan="2">
				<div class="control-group">
				<label class="control-label"><font color="red">*</font><strong>账单内容:</strong></label>
					<div class="controls">
						${bean['ITEM'] }
					</div>
		        </div>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div class="control-group">
				<label class="control-label"><font color="red">*</font><strong>发生地点:</strong></label>
					<div class="controls">
						${bean['PLACE'] }
					</div>
		        </div>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div class="control-group">
					<label class="control-label"><strong>备注:</strong></label>
					<div class="controls">${bean['REMARK'] }</div>
				</div>	
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div class="control-group">
					<label class="control-label"><strong>图片:</strong></label>
					<div class="controls">
				       <img id="billImage" src="${ctxStatic}/images/billImage/${bean.IMAGE}"
						onerror="javascript:this.src='${ctxStatic}/images/billImage/noimg.png'" />
					</div>
				</div>	
			</td>
		</tr>		
	</table>
</form:form>
</body>
</html>