<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>账单表单</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		var fileNameOld = "${bean.bean.IMAGE}";
		if(fileNameOld!=""){
			$("#file").attr("style","width:0px;filter:alpha(opacity=0); opacity: 0;");
			$("#fileChange").show();
			$("#file").attr("required",false);
		}
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
	
	function selectEmployee(){
		// 人员选择器	
			 top.$.jBox.open("iframe:${ctx}/wage/projectfee/feetype/employeeList", "&gt;&gt;教职工添加", 650, 540, {
				buttons:{"确定":"ok","关闭":true}, submit:function(v, h, f){
					if (v=="ok"){
						var radio = h.find("iframe").contents().find("input[name='sel_emp']:checked");
						var tr = radio.parent().parent();
						var employeeId = tr.find("td:eq(1)").text();
						var name = tr.find("td:eq(2)").text();
						var dept = tr.find("#dept_id").val();
						$("#EMPLOYEE_ID").val(employeeId);
						$("#DEPT").val(dept);
						$("#NAME").val(name);
					}
				},loaded:function(h){
					$(".jbox-content", top.document).css("overflow-y","hidden");
				}
			});	
	}
	function doPreviewPhoto(){
		var file = document.getElementById("file");
		var img = document.getElementById("billImage");
		var value = file.value;
		if(/^.*?\.(jpg|bmp|png)$/.test(value)){
			$("#file_isUp").val("1");
			$("#file").attr("style","");
			$("#fileChange").hide();
		}else{
			top.$.jBox.tip('选择的电子相片不是jpg, bmp, png格式，请重新选择！', 'warning',{timeout: 3500});
			return false;
		}
		var imgSize = 1024 * 1024 * 3; //最大3M
		var photoSize = 0;
		if(file.files && file.files[0]){//chrome \ firefox
			photoSize = file.files[0].size;
		}else{//IE
			photoSize = file.fileSize;
		}
		if(photoSize > imgSize){//'电子相片大小不能超过1M'
			top.$.jBox.tip('选择的图标大小不能超过3M，请重新选择！', 'warning',{timeout: 3500});
			return false;
		}
		if(file.files && file.files[0]){
			//火狐下，直接设img属性
			img.style.display = 'block';
			//火狐7以上版本不能用上面的getAsDataURL()方式获取，需要一下方式
			img.src = window.URL.createObjectURL(file.files[0]);
		}else{
			//IE下，使用滤镜
			file.select();
			$('#picDiv').focus();
			var imgSrc = document.selection.createRange().text;//获得选择区域的文本创建文本域和得到文本
			var localImagId = document.getElementById("localImag");
			//必须设置初始大小
			localImagId.style.width = "165px";
			localImagId.style.height = "200px";
			//图片异常的捕捉，防止用户修改后缀来伪造图片
			try{
				localImagId.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale)";
				localImagId.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = imgSrc;

			}catch(e){
				top.$.jBox.tip('您选择的图标不符合规定，请重新选择！', 'warning',{timeout: 3500});
				return false;
			}
			img.style.display = 'none';
			document.selection.empty();
		}
		return true;
	}
</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/bill/list">账单管理列表</a></li>
		<li class="active"><a href="${ctx}/bill/form?numId=${empty bean.bean.GUUID?'':bean.bean.GUUID}">${empty bean.bean.GUUID?"添加":"修改"}账单</a></li>
	</ul>
	<tags:orgmessage content="${message}"/>
	<form:form id="inputForm" modelAttribute="bean" action="${ctx}/bill/save" method="post"
		class="form-horizontal" enctype="multipart/form-data" >
		<form:hidden path="bean[GUUID]" />
		<input type="hidden" name="bean['oldImage']" value="${bean.bean.IMAGE }">
        <table border="0" style="height:100%;width:100%">
          <tr>
         <td>
                <div class="control-group">
	      <label class="control-label"><font color="red">*</font>账单主体:</label>
	      <div class="controls" id="tip">
	           <tags:sysEmployeeSelect id="blong" name="bean[BLONG]" value="${bean.bean.BLONG}" 
						labelName="bean[BLONG_NAME]" labelValue="${bean.bean.BLONG_NAME}" checked="false"
						title="消费人" cssClass="" cssStyle="width:115px;"/>
	       </div>
	      </div>
             </td>
             <td>
			     <div class="control-group">
				 <label class="control-label"><font color="red">*</font>账单时间:</label>
				    <div class="controls">
					    <input type="text" name="bean['CONSUME_TIME']" id="CONSUME_TIME" required="true" class="input-medium Wdate"  
						    value="${fns:formatDate(bean.bean['CONSUME_TIME'], 'yyyy-MM-dd HH:mm:ss') }" 
						    onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" />
					</div>
		        </div>
			</td>
          </tr>
          <tr>		  
	        <td>
	            <div class="control-group">
					<label class="control-label"><font color="red">*</font>收支类型:</label>
					<div class="controls">
						<form:select id="CONSUME_TYPE" path="bean['CONSUME_TYPE']" class="input-medium">
							<form:options items="${fns:getDictList('BILL_IN_OUT_TYPE')}" 
							itemValue="value" itemLabel="label" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
             </td>
             <td>
	            <div class="control-group">
					<label class="control-label"><font color="red">*</font>金额（元）:</label>
					<div class="controls">
						<form:input id="AMOUNT" path="bean['AMOUNT']"  
						value="${empty bean.bean.AMOUNT?0.0:bean.bean.AMOUNT}" htmlEscape="false" 
						maxlength="10" required="true" number="true" class="input-medium"/>
					</div>
				</div>
             </td>
          </tr>
          <tr>
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
			<td>
			        <div class="control-group">
					<label class="control-label"><font color="red">*</font>资金来源:</label>
					<div class="controls">
						<form:select path="bean['PAY_WAY']" class="input-medium" >
							<form:options items="${fns:getDictList('BILL_PAY_WAY')}" 
							itemValue="value" itemLabel="label" htmlEscape="false"/>
						</form:select>
					</div>
		           </div>
	       </td>
		</tr>
		<tr>
			<td colspan="2">
				<div class="control-group">
				<label class="control-label"><font color="red">*</font>账单内容:</label>
					<div class="controls">
						<form:input id="ITEM" path="bean['ITEM']" maxlength="60" required="true" 
						style="width:80%" />
					</div>
		        </div>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<div class="control-group">
				<label class="control-label"><font color="red">*</font>发生地点:</label>
					<div class="controls">
						<form:input path="bean['PLACE']" maxlength="50" required="true" 
						style="width:80%" />
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
		<tr>
			<td colspan="2">
				<div class="control-group">
					<label class="control-label">图片:</label>
					<div class="controls">
				       <img id="billImage" src="${ctxStatic}/images/billImage/${empty bean.bean.IMAGE?'noimg.png':bean.bean.IMAGE}"
				       	style="max-width:700px;max-height:284px;"
						onerror="javascript:this.src='${ctxStatic}/images/billImage/noimg.png'" />
						<label>
							<input type="file" id="file" name="file" style="width: 150px;" onchange="doPreviewPhoto()">
							<font id="fileChange" title="点击修改" style="display: none;"><img src="${ctxStatic}/images/button01.png"/></font>
						</label>
						<input  name="bean['FU']" id="file_isUp" type="hidden" value="0"/>
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