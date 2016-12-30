<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>站点登录信息列表</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {
		
	});
function page(n, s) {
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").attr("action", "${ctx}/mmh/account/list");
	$("#searchForm").submit();
	return false;
}
function reload() {
	$("#searchForm input[type='text']:not(:hidden)").val("");
	$("#searchForm").submit();
}
function modify(guid, title,type) {
	var index = layer.open({
		type: 2,
		area: ['800px', '450px'],
		maxmin: true,
		title: title,
		content: "${ctx}/mmh/account/form?id="+guid+(type=="add"?"&siteId="+$("#siteId").val():""),
		btn: ['保存','返回'],
		btnAlign: 'c',
		offset: "auto",
		yes: function (index, layero) {
			var inputForm = layer.getChildFrame('#inputForm', index);
			if(inputForm.valid()){
				$.ajax({
					type: "post",
					url: inputForm.attr("action"),
					data: inputForm.serialize(),
					success: function(data) {
						if(data=="OK"){
							layer.close(index);
							top.layer.msg("操作成功！", {time: 1500, icon:6});
					    	$('#searchForm').submit();
						}else{
							layer.msg(data,{time:2000,icon:2});
						}
					},error: function(data) {
						layer.msg(data,{time:2000,icon:2});
					}
				});
			}
		},btn2: function (index) {
			layer.close(index);
		}
	});
}
function del(guid){
	layer.confirm("确认删除站点登录信息吗？", {
	    title: '提示', icon: 0,
	    btn: ['确定', '取消'] //按钮
	}, function () {
	    $.ajax({
	        type: "post",
	        data: {"deleteId": guid},
	        dataType: "text",
	        url: "${ctx}/mmh/account/delete",
	        success: function (data) {
	        	if(data=="OK"){
			    	top.layer.msg("操作成功！", {time: 1500, icon:6});
			    	$('#searchForm').submit();
				}else{
					layer.msg("操作失败："+data,{time:2000,icon:2});
				}
	        }
	    });
	});
}

function viewPwd(id){
	$.ajax({
		type: "POST",
		dataType: "text",
		data: {"id" : id},
		url:"${ctx}/mmh/account/getInfo",
		success : function(data){
			layer.tips(data, "#"+id,{time:2500});
		}
	});
}
</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/mmh/account/list">
		<input id="siteId" name="bean['SITE_ID']" type="hidden" value="${map.bean.SITE_ID}" />
		<table border="0">
			<tr>
				<td><label>关联手机：</label></td>
				<td><form:input path="bean['CON_PHONE']" htmlEscape="false"
						maxlength="32" class="input-small" /></td>
				<td><label>关联邮箱：</label> </td>
				<td><form:input path="bean['CON_EMAIL']" htmlEscape="false"
						maxlength="32" class="input-small" />
				</td>
				<td><label>名称：</label></td>
				<td><form:input path="bean['ACCOUNT']" htmlEscape="false"
						maxlength="32" class="input-small" /></td>
				
			</tr>
			<tr>
				<td colspan="6" align="right">
					<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"
						onclick="return page();">
					&nbsp;&nbsp;<input id="btnCancel" class="btn btn-primary" type="button" value="重置"
						onclick="return reload();" />
					&nbsp;&nbsp;
						<a href="javascript:modify('','添加账号信息','add');" class="btn btn-primary">
						<i class="iconfont f16 mr5">&#xe63f;</i>添加</a>
				</td>
			</tr>
		</table>
	</form:form>
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="120px">用户名</th>
				<th>关联手机</th>
				<th>关联邮箱</th>
				<th>创建时间</th>
				<th>备注</th>
				<th width="200px">操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${accountList}" var="bean">
				<tr>
				<td>${bean['ACCOUNT']}</td>
				<td>${bean['CON_PHONE']}</td>
				<td>${bean['CON_EMAIL']}</td>
				<td>${fns:formatDate(bean['CREATE_TIME'], 'yyyy-MM-dd HH:mm:ss') }</td>
				<td title="${bean['REMARK']}">${fn:substring(bean['REMARK'],0,10)}</td>
				<td><a href="javascript:modify('${bean.ID}','账号修改')"><i class="iconfont f16">&#xe619;</i></a>
				&nbsp;|&nbsp;<a href="javascript:del('${bean.ID}')"><i class="iconfont f16">&#xe617;</i></a>
				&nbsp;|&nbsp;<a id="${bean.ID}" href="javascript:viewPwd('${bean.ID}')" title="查看密码">
					<i id="iconIcon" class="iconfont f16">&#xe633;</i></a>
				</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>