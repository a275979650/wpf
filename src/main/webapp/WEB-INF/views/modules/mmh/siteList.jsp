<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>站点列表</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {
		$("#tableHead").click(function() {
			if ($(this).attr("checked")) {
				$("#contentTable tbody :checkbox[name='rowSelect']").attr("checked", true);
				} else {
					$("#contentTable tbody :checkbox[name='rowSelect']").attr("checked", false);
				}
		});

});
function page(n, s) {
	$("#pageNo").val(n);
	$("#pageSize").val(s);
	$("#searchForm").attr("action", "${ctx}/mmh/site/list");
	$("#searchForm").submit();
	return false;
}
function reload() {
	window.location.href = "${ctx}/mmh/site/list";
}
function modify(guid,siteName) {
	var index = layer.open({
		type: 2,
		area: ['800px', '450px'],
		maxmin: true,
		title: siteName,
		content: "${ctx}/mmh/site/form?id="+guid,
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
	layer.confirm("确认删除站点信息吗(包含登录信息)？", {
	    title: '提示', icon: 0,
	    btn: ['确定', '取消'] //按钮
	}, function () {
	    $.ajax({
	        type: "post",
	        data: {"deleteId": guid},
	        dataType: "text",
	        url: "${ctx}/mmh/site/delete",
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

function detail(guid,siteName) {
	var index = layer.open({
		type: 2,
		area: ['700px', '350px'],
		maxmin: true,
		title: siteName,
		content: '${ctx}/mmh/account/list?siteId='+guid
	});
	layer.full(index);
}
</script>
</head>
<body>
	<div style="display:none;"><tags:orgmessage content="${message}" /></div>
	<form:form id="searchForm" modelAttribute="map" class="breadcrumb form-search" method="post"
		action="${ctx}/mmh/site/list">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}" />
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}" />
		<table border="0"
			<tr>
				<td><label>站点类型：</label></td>
				<td><form:select path="bean['TYPE']" class="input-small">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('MMH_SITE_TYPE')}" 
							itemValue="value" itemLabel="label" htmlEscape="false"/>
					</form:select></td>
				<td><label>分类标签：</label> </td>
				<td><form:select path="bean['TAGLIB']" class="input-small">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('MMH_SITE_FLAG')}" 
							itemValue="value" itemLabel="label" htmlEscape="false"/>
					</form:select>
				</td>
				<td><label>名称：</label></td>
				<td><form:input path="bean['NAME']" htmlEscape="false"
						maxlength="32" class="input-small" /></td>
				<td>
					&nbsp;&nbsp; <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"
						onclick="return page();">
					<input id="btnCancel" class="btn btn-primary" type="button" value="重置"
						onclick="return reload();" />
				</td>
				<td align="right">
					<a href="javascript:modify('','添加站点信息');" class="btn btn-primary"><i class="iconfont f16 mr5">&#xe63f;</i>添加</a>
				</td>
			</tr>
		</table>
	</form:form>
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="12px"><input type="checkbox" id="tableHead"></th>
				<th width="60px">类型</th>
				<th>名称</th>
				<th>URL</th>
				<th width="60px">标签</th>
				<th>简介</th>
				<th width="120px">创建时间</th>
				<th>备注</th>
				<th width="150px">操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${page.list}" var="bean">
				<tr>
				<td><input type="checkbox" name="rowSelect"
					value="${bean['ID']}" /></td>
				<td>${fns:getDictLabel(bean['TYPE'], 'MMH_SITE_TYPE', '')}</td>
				<td>${bean['NAME']}</td>
				<td>${bean['URL']}</td>
				<td>${fns:getDictLabel(bean['TAGLIB'], 'MMH_SITE_FLAG', '')}</td>
				<td title="${bean['EXPLAIN']}">${fn:substring(bean['EXPLAIN'],0,30)}</td>
				<td>${fns:formatDate(bean['CREATE_TIME'], 'yyyy-MM-dd HH:mm:ss') }</td>
				<td title="${bean['REMARK']}">${fn:substring(bean['REMARK'],0,10)}</td>
				<td><a href="javascript:modify('${bean.ID}','修改站点信息--${bean.NAME}')"><i class="iconfont f16">&#xe619;</i></a>
				&nbsp;|&nbsp;<a href="javascript:del('${bean.ID}')"><i class="iconfont f16">&#xe617;</i></a>
				&nbsp;|&nbsp;<a href="javascript:detail('${bean.ID}','${bean.NAME }')" title="查看详细">
					<i class="iconfont f16">&#xe638;</i></a>
				</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>